#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_PROJECT_DIR="$(cd "$SCRIPT_DIR/.." 2>/dev/null && pwd || printf '')"
CONFIG_FILE=""

usage() {
  cat <<'USAGE'
Usage: restore_all.sh [options]

Runs restore_project.sh for every enabled project in backup.projects.json.
Default mode is dry-run; pass --apply to write files.

Options are forwarded to restore_project.sh:
  --apply
  --config PATH
  --backup-root PATH
  -h, --help
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ -f "$SCRIPT_DIR/backup.projects.json" ]]; then
  CONFIG_FILE="$SCRIPT_DIR/backup.projects.json"
elif [[ -f "$LOCAL_PROJECT_DIR/config/backup.projects.json" ]]; then
  CONFIG_FILE="$LOCAL_PROJECT_DIR/config/backup.projects.json"
else
  echo "ERROR: Cannot find backup.projects.json" >&2
  exit 1
fi

command -v jq >/dev/null 2>&1 || {
  echo "ERROR: Required command not found: jq" >&2
  exit 1
}

while IFS= read -r project_id; do
  echo
  echo "=== Restoring project: $project_id ==="
  "$SCRIPT_DIR/restore_project.sh" "$project_id" --config "$CONFIG_FILE" "$@"
done < <(jq -r '.projects[] | select(.enabled == true) | .id' "$CONFIG_FILE")
