#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TS="$(date -u +%H%M%S_%d%m%Y)"
OUT_DIR="$PROJECT_DIR/test-results/dry-run-output_$TS"
MANIFEST="$OUT_DIR/manifest.txt"
SUMMARY="$OUT_DIR/summary.txt"

mkdir -p "$OUT_DIR"

SOURCE_FOLDERS=(
  "/root/.openclaw/workspace/projects/apple-watch-assistant"
  "/root/.openclaw/workspace/projects/dashboard-progress-tracker"
  "/root/.openclaw/workspace/projects/backup-dinh-ky-du-lieu-code"
  "/root/.openclaw/workspace/team_logs"
)

EXCLUDES=(
  ".env"
  ".env.*"
  "*.pem"
  "*.key"
  "*.p12"
  "*.crt"
  "id_rsa"
  "id_ed25519"
  "*token*"
  "*credentials*"
  "node_modules"
  ".git"
  "__pycache__"
  "logs"
  "cache"
  "tmp"
)

FIND_ARGS=()
for src in "${SOURCE_FOLDERS[@]}"; do
  if [[ -d "$src" ]]; then
    FIND_ARGS+=("$src")
  fi
done

if [[ ${#FIND_ARGS[@]} -eq 0 ]]; then
  echo "No source folders found" >&2
  exit 1
fi

PRUNE_EXPR=( )
for pat in "${EXCLUDES[@]}"; do
  PRUNE_EXPR+=( -name "$pat" -o )
done
unset 'PRUNE_EXPR[${#PRUNE_EXPR[@]}-1]'

find "${FIND_ARGS[@]}" \
  \( "${PRUNE_EXPR[@]}" \) -prune -o \
  -type f -print | sort > "$MANIFEST"

FILE_COUNT=$(wc -l < "$MANIFEST" | tr -d ' ')
EST_SIZE=$(python3 - <<'PY' "$MANIFEST"
import os, sys
manifest = sys.argv[1]
total = 0
with open(manifest, 'r', encoding='utf-8') as f:
    for line in f:
        p = line.strip()
        if not p:
            continue
        try:
            total += os.path.getsize(p)
        except OSError:
            pass
units = ['B','KB','MB','GB','TB']
size = float(total)
unit = units[0]
for u in units:
    unit = u
    if size < 1024 or u == units[-1]:
        break
    size /= 1024.0
print(f"{size:.2f} {unit}")
PY
)

{
  echo "mode=dry-run"
  echo "timestamp_utc=$TS"
  echo "source_folders=${SOURCE_FOLDERS[*]}"
  echo "excluded_patterns=${EXCLUDES[*]}"
  echo "file_count=$FILE_COUNT"
  echo "estimated_size=$EST_SIZE"
  echo "output_path=$OUT_DIR"
  echo "manifest_path=$MANIFEST"
  echo "push_github=false"
  echo "delete_data=false"
} > "$SUMMARY"

echo "Dry-run summary written to: $SUMMARY"
echo "Manifest written to: $MANIFEST"
