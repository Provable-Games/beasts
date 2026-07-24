#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="${1:-.github/review-agents.json}"
BASE_SHA="${2:-}"
HEAD_SHA="${3:-}"

if [ -z "$BASE_SHA" ] || [ -z "$HEAD_SHA" ]; then
  echo "usage: $0 <config-file> <base-sha> <head-sha>" >&2
  exit 1
fi

if [ ! -f "$CONFIG_FILE" ]; then
  echo "config file not found: $CONFIG_FILE" >&2
  exit 1
fi

CHANGED_FILES_JSON=$(git diff --name-only "$BASE_SHA...$HEAD_SHA" | jq -R -s 'split("\n") | map(select(length > 0))')

MATRIX_JSON=$(jq -c --argjson changed_files "$CHANGED_FILES_JSON" '
{
  include: [
    .agents[]
    | select([.diff_paths[] as $path | $changed_files[] | startswith($path)] | any)
    | . + { diff_paths_str: (.diff_paths | join(" ")) }
  ]
}
' "$CONFIG_FILE")

HAS_REVIEWS=$(echo "$MATRIX_JSON" | jq -r 'if (.include | length) > 0 then "true" else "false" end')

if [ -n "${GITHUB_OUTPUT:-}" ]; then
  echo "matrix=$MATRIX_JSON" >> "$GITHUB_OUTPUT"
  echo "has-reviews=$HAS_REVIEWS" >> "$GITHUB_OUTPUT"
else
  echo "$MATRIX_JSON"
  echo "$HAS_REVIEWS"
fi
