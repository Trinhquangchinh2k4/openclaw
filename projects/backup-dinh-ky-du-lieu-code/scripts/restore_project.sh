#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_PROJECT_DIR="$(cd "$SCRIPT_DIR/.." 2>/dev/null && pwd || printf '')"
CONFIG_FILE=""
BACKUP_ROOT=""
APPLY=false

usage() {
  cat <<'USAGE'
Usage: restore_project.sh <project-id> [options]

Default mode is dry-run. It prints the project manifest and restore plan.
No files are written or overwritten unless --apply is supplied.

Options:
  --apply              Restore files to target paths.
  --config PATH        Use an alternate backup.projects.json.
  --backup-root PATH   Use an alternate backups/ root.
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

PROJECT_ID="${1:-}"
if [[ -z "$PROJECT_ID" || "$PROJECT_ID" == "-h" || "$PROJECT_ID" == "--help" ]]; then
  usage
  exit 0
fi
shift

while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply)
      APPLY=true
      shift
      ;;
    --config)
      CONFIG_FILE="${2:-}"
      [[ -n "$CONFIG_FILE" ]] || fail "--config requires a path"
      shift 2
      ;;
    --backup-root)
      BACKUP_ROOT="${2:-}"
      [[ -n "$BACKUP_ROOT" ]] || fail "--backup-root requires a path"
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

need_cmd jq
need_cmd rsync

if [[ -z "$CONFIG_FILE" ]]; then
  if [[ -f "$SCRIPT_DIR/backup.projects.json" ]]; then
    CONFIG_FILE="$SCRIPT_DIR/backup.projects.json"
  elif [[ -f "$LOCAL_PROJECT_DIR/config/backup.projects.json" ]]; then
    CONFIG_FILE="$LOCAL_PROJECT_DIR/config/backup.projects.json"
  else
    fail "Cannot find backup.projects.json"
  fi
fi

[[ -f "$CONFIG_FILE" ]] || fail "Registry not found: $CONFIG_FILE"
jq empty "$CONFIG_FILE" >/dev/null

if [[ -z "$BACKUP_ROOT" ]]; then
  if [[ -n "${OPENCLAW_BACKUP_ROOT:-}" ]]; then
    BACKUP_ROOT="$OPENCLAW_BACKUP_ROOT"
  elif [[ -f "$SCRIPT_DIR/backup.projects.json" ]]; then
    BACKUP_ROOT="$SCRIPT_DIR"
  else
    repo_dir="$(jq -r '.repo.localPath // "/root/.openclaw/backups/openclaw-code-backup"' "$CONFIG_FILE")"
    BACKUP_ROOT="$repo_dir/backups"
  fi
fi

project_json="$(jq -c --arg id "$PROJECT_ID" '.projects[] | select(.id == $id)' "$CONFIG_FILE")"
[[ -n "$project_json" ]] || fail "Project id not found in registry: $PROJECT_ID"

backup_subdir="$(jq -r '.backupSubdir' <<<"$project_json")"
restore_path="$(jq -r '.restorePath' <<<"$project_json")"
backup_rel="${backup_subdir#backups/}"
project_backup="$BACKUP_ROOT/$backup_rel"
manifest_file="$project_backup/manifest.txt"

[[ -d "$project_backup" ]] || fail "Project backup directory not found: $project_backup"
[[ -f "$manifest_file" ]] || fail "Manifest not found: $manifest_file"

source_key() {
  local idx="$1"
  local source_path="$2"
  local base safe_base
  base="$(basename "$source_path")"
  safe_base="$(printf '%s' "$base" | tr -c 'A-Za-z0-9._-' '-')"
  printf '%02d-%s' "$idx" "$safe_base"
}

echo "Restore project: $PROJECT_ID"
echo "Mode: $([[ "$APPLY" == "true" ]] && echo apply || echo dry-run)"
echo "Backup directory: $project_backup"
echo "Primary restorePath: $restore_path"
echo
echo "Manifest: $manifest_file"
sed -n '1,160p' "$manifest_file"
manifest_lines="$(wc -l < "$manifest_file" | tr -d ' ')"
if [[ "$manifest_lines" -gt 160 ]]; then
  echo "... manifest truncated after 160 lines; inspect file for full list."
fi
echo
echo "Restore plan:"

idx=0
while IFS= read -r source_path; do
  idx=$((idx + 1))
  key="$(source_key "$idx" "$source_path")"
  source_snapshot="$project_backup/sources/$key"
  [[ -d "$source_snapshot" ]] || fail "Source snapshot not found: $source_snapshot"

  if [[ "$idx" -eq 1 ]]; then
    target_path="$restore_path"
  else
    target_path="$source_path"
  fi

  echo "- $source_snapshot/ -> $target_path/"
  if [[ "$APPLY" == "true" ]]; then
    mkdir -p "$target_path"
    rsync -a --itemize-changes "$source_snapshot"/ "$target_path"/
  else
    rsync -ani "$source_snapshot"/ "$target_path"/ || true
  fi
done < <(jq -r '.sourcePaths[]' <<<"$project_json")

if [[ "$APPLY" != "true" ]]; then
  echo
  echo "Dry-run only. Re-run with --apply to write files."
fi
