#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_FILE="$PROJECT_DIR/config/backup.projects.json"
GLOBAL_EXCLUDE_FILE="$PROJECT_DIR/config/backup.exclude"
TIMESTAMP="$(date -u +%H%M%S_%d%m%Y)"

APPLY=false
PUSH_REQUESTED=false
CHECK_REMOTE=false
CREATE_TAG=false
PRINT_PUBLIC_KEY=false
CONFIG_OVERRIDE=""
REPO_DIR_OVERRIDE=""

usage() {
  cat <<'USAGE'
Usage: backup_push_github.sh [options]

Default mode is a local dry-run. It reads config/backup.projects.json,
builds manifests and rsync plans, and does not clone, commit, or push.

Options:
  --apply              Sync enabled projects into the local backup repo and commit.
  --push               Push only with --apply and an explicit approved manual/cron command.
  --tag                Create an annotated backup tag for the local commit.
  --check-remote       Run git ls-remote against the configured SSH remote.
  --print-public-key   Print the deploy public key once; never prints private keys.
  --config PATH        Use an alternate backup.projects.json.
  --repo-dir PATH      Use an alternate local backup repository path.
  -h, --help           Show this help.
USAGE
}

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "Required command not found: $1"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply)
      APPLY=true
      shift
      ;;
    --push)
      PUSH_REQUESTED=true
      shift
      ;;
    --tag)
      CREATE_TAG=true
      shift
      ;;
    --check-remote)
      CHECK_REMOTE=true
      shift
      ;;
    --print-public-key)
      PRINT_PUBLIC_KEY=true
      shift
      ;;
    --config)
      CONFIG_OVERRIDE="${2:-}"
      [[ -n "$CONFIG_OVERRIDE" ]] || fail "--config requires a path"
      shift 2
      ;;
    --repo-dir)
      REPO_DIR_OVERRIDE="${2:-}"
      [[ -n "$REPO_DIR_OVERRIDE" ]] || fail "--repo-dir requires a path"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "Unknown argument: $1"
      ;;
  esac
done

if [[ -n "$CONFIG_OVERRIDE" ]]; then
  CONFIG_FILE="$CONFIG_OVERRIDE"
fi

need_cmd jq
need_cmd rsync
need_cmd git
need_cmd sha256sum

[[ -f "$CONFIG_FILE" ]] || fail "Registry not found: $CONFIG_FILE"
[[ -f "$GLOBAL_EXCLUDE_FILE" ]] || fail "Global exclude file not found: $GLOBAL_EXCLUDE_FILE"
jq empty "$CONFIG_FILE" >/dev/null

HTTPS_URL="$(jq -r '.repo.httpsUrl // empty' "$CONFIG_FILE")"
SSH_URL="$(jq -r '.repo.sshUrl // empty' "$CONFIG_FILE")"
BRANCH="$(jq -r '.repo.branch // "main"' "$CONFIG_FILE")"
REPO_DIR="$(jq -r '.repo.localPath // "/root/.openclaw/backups/openclaw-code-backup"' "$CONFIG_FILE")"
PUSH_ENABLED="$(jq -r '.settings.pushEnabled // false' "$CONFIG_FILE")"
CRON_ENABLED="$(jq -r '.settings.cronEnabled // false' "$CONFIG_FILE")"
BACKUP_TIMES_ICT="$(jq -r '.settings.backupTimesICT // [] | join(",")' "$CONFIG_FILE")"
DEPLOY_KEY_FILE="$PROJECT_DIR/github-push/openclaw_backup_github_ed25519"

if [[ -n "$REPO_DIR_OVERRIDE" ]]; then
  REPO_DIR="$REPO_DIR_OVERRIDE"
fi

[[ -n "$SSH_URL" ]] || fail "repo.sshUrl is required"
[[ -n "$BRANCH" ]] || fail "repo.branch is required"

if [[ -z "${GIT_SSH_COMMAND:-}" && -f "$DEPLOY_KEY_FILE" ]]; then
  export GIT_SSH_COMMAND="ssh -i $DEPLOY_KEY_FILE -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new"
fi

export GIT_AUTHOR_NAME="${GIT_AUTHOR_NAME:-OpenClaw Backup}"
export GIT_AUTHOR_EMAIL="${GIT_AUTHOR_EMAIL:-openclaw-backup@local}"
export GIT_COMMITTER_NAME="${GIT_COMMITTER_NAME:-OpenClaw Backup}"
export GIT_COMMITTER_EMAIL="${GIT_COMMITTER_EMAIL:-openclaw-backup@local}"

REPORT_DIR="$PROJECT_DIR/test-results/backup-dry-run_$TIMESTAMP"
TMP_DIR="$(mktemp -d)"
EMPTY_DIR="$TMP_DIR/empty"
mkdir -p "$EMPTY_DIR"
trap 'rm -rf "$TMP_DIR"' EXIT

if [[ "$PRINT_PUBLIC_KEY" == "true" ]]; then
  PUBLIC_KEY_FILE="${OPENCLAW_BACKUP_PUBLIC_KEY:-$PROJECT_DIR/github-push/openclaw_backup_github_ed25519.pub}"
  PRINT_MARKER="$PROJECT_DIR/.state/deploy_public_key_printed"
  [[ -f "$PUBLIC_KEY_FILE" ]] || fail "Public deploy key not found: $PUBLIC_KEY_FILE"
  mkdir -p "$(dirname "$PRINT_MARKER")"
  if [[ -f "$PRINT_MARKER" ]]; then
    echo "Public deploy key was already printed from: $PUBLIC_KEY_FILE"
  else
    echo "Public deploy key for GitHub deploy-key setup:"
    sed -n '1p' "$PUBLIC_KEY_FILE"
    date -u +%FT%TZ > "$PRINT_MARKER"
  fi
fi

if [[ "$CHECK_REMOTE" == "true" ]]; then
  echo "Checking remote access with git ls-remote: $SSH_URL"
  git ls-remote "$SSH_URL" "$BRANCH" >/dev/null
  echo "Remote check passed for branch: $BRANCH"
fi

if [[ "$APPLY" == "true" ]]; then
  if [[ -d "$REPO_DIR/.git" ]]; then
    if git -C "$REPO_DIR" show-ref --verify --quiet "refs/heads/$BRANCH"; then
      git -C "$REPO_DIR" checkout "$BRANCH" >/dev/null
    elif git -C "$REPO_DIR" show-ref --verify --quiet "refs/remotes/origin/$BRANCH"; then
      git -C "$REPO_DIR" checkout -B "$BRANCH" "origin/$BRANCH" >/dev/null
    else
      git -C "$REPO_DIR" checkout -B "$BRANCH" >/dev/null
    fi
  else
    mkdir -p "$(dirname "$REPO_DIR")"
    git clone "$SSH_URL" "$REPO_DIR"
    if git -C "$REPO_DIR" show-ref --verify --quiet "refs/heads/$BRANCH"; then
      git -C "$REPO_DIR" checkout "$BRANCH" >/dev/null
    elif git -C "$REPO_DIR" show-ref --verify --quiet "refs/remotes/origin/$BRANCH"; then
      git -C "$REPO_DIR" checkout -B "$BRANCH" "origin/$BRANCH" >/dev/null
    else
      git -C "$REPO_DIR" checkout -B "$BRANCH" >/dev/null
    fi
  fi
  BACKUP_ROOT="$REPO_DIR/backups"
else
  BACKUP_ROOT="$REPORT_DIR/repo-preview/backups"
fi

SUMMARY_FILE="$BACKUP_ROOT/reports/${TIMESTAMP}_backup_summary.txt"
LATEST_SUMMARY_FILE="$BACKUP_ROOT/backup-system/backup_summary_latest.txt"

mkdir -p "$BACKUP_ROOT/projects" "$BACKUP_ROOT/backup-system" "$BACKUP_ROOT/reports"
cp "$CONFIG_FILE" "$BACKUP_ROOT/backup.projects.json"
cp "$GLOBAL_EXCLUDE_FILE" "$BACKUP_ROOT/backup.exclude"
cp "$SCRIPT_DIR/restore_project.sh" "$BACKUP_ROOT/restore_project.sh"
cp "$SCRIPT_DIR/restore_all.sh" "$BACKUP_ROOT/restore_all.sh"
chmod +x "$BACKUP_ROOT/restore_project.sh" "$BACKUP_ROOT/restore_all.sh"

source_key() {
  local idx="$1"
  local source_path="$2"
  local base safe_base
  base="$(basename "$source_path")"
  safe_base="$(printf '%s' "$base" | tr -c 'A-Za-z0-9._-' '-')"
  printf '%02d-%s' "$idx" "$safe_base"
}

project_exclude_file() {
  local project_json="$1"
  local output_file="$2"
  cp "$GLOBAL_EXCLUDE_FILE" "$output_file"
  jq -r '.excludes[]?' <<<"$project_json" >> "$output_file"
}

generate_source_manifest() {
  local source_path="$1"
  local key="$2"
  local exclude_file="$3"
  local manifest_file="$4"
  local rel source_file size sha

  rsync -a --dry-run --out-format='%n' --exclude-from="$exclude_file" "$source_path"/ "$EMPTY_DIR"/ \
    | while IFS= read -r rel; do
        [[ -n "$rel" ]] || continue
        [[ "$rel" != "./" ]] || continue
        [[ "$rel" != */ ]] || continue
        source_file="$source_path/$rel"
        [[ -f "$source_file" ]] || continue
        size="$(stat -c '%s' "$source_file" 2>/dev/null || printf '0')"
        if sha="$(sha256sum "$source_file" 2>/dev/null | awk '{print $1}')"; then
          :
        else
          sha="unreadable"
        fi
        printf '%s\t%s\t%s\t%s\t%s\n' "$key" "$size" "$sha" "$rel" "$source_file"
      done >> "$manifest_file"
}

write_project_manifest_header() {
  local manifest_file="$1"
  local project_id="$2"
  local backup_subdir="$3"
  local restore_path="$4"

  {
    echo "project_id=$project_id"
    echo "timestamp_utc=$TIMESTAMP"
    echo "backup_subdir=$backup_subdir"
    echo "restore_path=$restore_path"
    echo "manifest_format=source_key<TAB>size_bytes<TAB>sha256<TAB>relative_path<TAB>source_path"
    echo
    echo "[files]"
  } > "$manifest_file"
}

TOTAL_PROJECTS=0
TOTAL_FILES=0
TOTAL_BYTES=0

{
  echo "OpenClaw disaster recovery backup summary"
  echo "timestamp_utc=$TIMESTAMP"
  echo "mode=$([[ "$APPLY" == "true" ]] && echo apply || echo dry-run)"
  echo "repo_https=$HTTPS_URL"
  echo "repo_ssh=$SSH_URL"
  echo "branch=$BRANCH"
  echo "pushEnabled=$PUSH_ENABLED"
  echo "cronEnabled=$CRON_ENABLED"
  echo "backupTimesICT=$BACKUP_TIMES_ICT"
  echo "pushRequested=$PUSH_REQUESTED"
  echo
  echo "[projects]"
} > "$SUMMARY_FILE"

while IFS= read -r project_json; do
  project_id="$(jq -r '.id' <<<"$project_json")"
  restore_path="$(jq -r '.restorePath' <<<"$project_json")"
  backup_subdir="$(jq -r '.backupSubdir' <<<"$project_json")"
  [[ "$backup_subdir" == backups/projects/* ]] || fail "backupSubdir must stay under backups/projects/: $project_id"

  project_dest="$REPO_DIR/$backup_subdir"
  if [[ "$APPLY" != "true" ]]; then
    project_dest="$REPORT_DIR/repo-preview/$backup_subdir"
  fi

  mkdir -p "$project_dest/sources"
  manifest_file="$project_dest/manifest.txt"
  plan_file="$project_dest/rsync-plan.txt"
  exclude_file="$TMP_DIR/$project_id.exclude"
  project_exclude_file "$project_json" "$exclude_file"
  write_project_manifest_header "$manifest_file" "$project_id" "$backup_subdir" "$restore_path"
  : > "$plan_file"

  idx=0
  while IFS= read -r source_path; do
    idx=$((idx + 1))
    [[ -d "$source_path" ]] || fail "Source path not found for $project_id: $source_path"
    key="$(source_key "$idx" "$source_path")"
    source_dest="$project_dest/sources/$key"
    mkdir -p "$source_dest"

    echo "[$project_id] $source_path -> $backup_subdir/sources/$key"
    if [[ "$APPLY" == "true" ]]; then
      rsync -a --delete --delete-excluded --exclude-from="$exclude_file" "$source_path"/ "$source_dest"/
    else
      rsync -ani --delete --delete-excluded --exclude-from="$exclude_file" "$source_path"/ "$source_dest"/ >> "$plan_file"
    fi

    generate_source_manifest "$source_path" "$key" "$exclude_file" "$manifest_file"
  done < <(jq -r '.sourcePaths[]' <<<"$project_json")

  file_count="$(awk 'BEGIN{n=0} /^\[files\]/{seen=1; next} seen && NF{n++} END{print n}' "$manifest_file")"
  byte_count="$(awk 'BEGIN{s=0} /^\[files\]/{seen=1; next} seen && NF{s+=$2} END{print s}' "$manifest_file")"
  TOTAL_PROJECTS=$((TOTAL_PROJECTS + 1))
  TOTAL_FILES=$((TOTAL_FILES + file_count))
  TOTAL_BYTES=$((TOTAL_BYTES + byte_count))

  {
    echo "$project_id files=$file_count bytes=$byte_count backup_subdir=$backup_subdir restore_path=$restore_path"
  } >> "$SUMMARY_FILE"
done < <(jq -c '.projects[] | select(.enabled == true)' "$CONFIG_FILE")

{
  echo
  echo "[totals]"
  echo "projects=$TOTAL_PROJECTS"
  echo "files=$TOTAL_FILES"
  echo "bytes=$TOTAL_BYTES"
  echo
  echo "[safety]"
  echo "source_delete=false"
  echo "force_push=false"
  echo "private_key_printed=false"
  echo "excluded_file=$GLOBAL_EXCLUDE_FILE"
} >> "$SUMMARY_FILE"

cp "$SUMMARY_FILE" "$LATEST_SUMMARY_FILE"

if [[ "$APPLY" == "true" ]]; then
  git -C "$REPO_DIR" add backups
  if git -C "$REPO_DIR" diff --cached --quiet; then
    echo "No backup changes to commit."
  else
    git -C "$REPO_DIR" commit -m "backup: OpenClaw disaster recovery snapshot $TIMESTAMP"
  fi

  if [[ "$CREATE_TAG" == "true" ]]; then
    TAG_NAME="openclaw-backup-$TIMESTAMP"
    if git -C "$REPO_DIR" rev-parse "$TAG_NAME" >/dev/null 2>&1; then
      echo "Tag already exists locally: $TAG_NAME"
    else
      git -C "$REPO_DIR" tag -a "$TAG_NAME" -m "OpenClaw disaster recovery backup $TIMESTAMP"
      echo "Created local tag: $TAG_NAME"
    fi
  fi
fi

if [[ "$PUSH_REQUESTED" == "true" ]]; then
  [[ "$APPLY" == "true" ]] || fail "--push requires --apply"
  if [[ "$PUSH_ENABLED" != "true" ]]; then
    echo "settings.pushEnabled=false; proceeding because --push was explicitly requested for an approved manual run."
  fi
  git -C "$REPO_DIR" push origin "$BRANCH"
  if [[ "$CREATE_TAG" == "true" ]]; then
    git -C "$REPO_DIR" push origin "$TAG_NAME"
  fi
fi

echo "Backup summary: $SUMMARY_FILE"
if [[ "$APPLY" != "true" ]]; then
  echo "Dry-run preview root: $REPORT_DIR/repo-preview"
fi
