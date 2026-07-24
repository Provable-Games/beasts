#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-}"
OUTPUT_FILE="${2:-/tmp/prompt.txt}"

if [ -z "$MODE" ]; then
  echo "usage: $0 <codex|claude> [output-file]" >&2
  exit 1
fi

: "${PROMPT_FILE:?PROMPT_FILE is required}"
: "${DIFF_PATHS_STR:?DIFF_PATHS_STR is required}"
: "${BASE_SHA:?BASE_SHA is required}"
: "${HEAD_SHA:?HEAD_SHA is required}"
: "${PR_NUMBER:?PR_NUMBER is required}"
: "${REPOSITORY:?REPOSITORY is required}"

AGENT_NAME="${AGENT_NAME:-Reviewer}"
COMMENT_HEADER="${COMMENT_HEADER:-Review}"
PR_TITLE="${PR_TITLE:-}"
PR_BODY="${PR_BODY:-}"

git diff --name-only "$BASE_SHA...$HEAD_SHA" -- $DIFF_PATHS_STR > /tmp/scoped-files.txt

{
  cat "$PROMPT_FILE"
  echo ""
  echo "---"
  echo ""
  echo "This is PR #$PR_NUMBER for $REPOSITORY."
  echo ""
  echo "Targeted reviewer: $AGENT_NAME"
  echo "Published comment title: $COMMENT_HEADER"
  echo "Review scope: $DIFF_PATHS_STR"
  echo ""
  echo "Allowed file list (all findings must reference these files):"
  sed 's/^/- /' /tmp/scoped-files.txt
  echo ""
  echo "Use this exact scoped diff command:"
  echo "  git diff $BASE_SHA...$HEAD_SHA -- $DIFF_PATHS_STR"
  echo ""
  echo "Pull request title: $PR_TITLE"
  echo "Pull request body:"
  echo "$PR_BODY"
  echo ""
  echo "---"
  echo ""

  case "$MODE" in
    codex)
      cat <<'EOF'
Output requirements:
- Do not write a heading/title; the workflow will add the comment title.
- If no actionable findings exist, output exactly: lgtm
- Otherwise, keep the comment concise: list only actionable findings, ordered by severity.
- Do not include summaries, praise, or testing-gap notes unless they are tied to a specific finding.
- Limit the review to the highest-signal findings.

Format each finding as:
[SEVERITY] file_path:line_number - description
Impact: what breaks and when
Fix: concrete code change

Where SEVERITY is one of: CRITICAL, HIGH, MEDIUM, LOW, INFO
EOF
      ;;
    claude)
      cat <<EOF
Hard scope rules:
- Every finding must cite a file from the allowed file list above.
- Do not inspect or mention files outside the allowed list.
- If no actionable findings exist in scoped files, say exactly: lgtm

Output requirements:
- Do not write a heading/title; the workflow will add the comment title.
- Keep findings strictly scoped to files in the allowed list.
- Keep the comment concise: list only actionable findings, ordered by severity.
- Do not include summaries, praise, or testing-gap notes unless they are tied to a specific finding.
- Limit the review to the highest-signal findings.
- Format each finding as:
  [SEVERITY] file_path:line_number - description
  Impact: what breaks and when
  Fix: concrete code change
EOF
      ;;
    *)
      echo "unsupported mode: $MODE" >&2
      exit 1
      ;;
  esac
} > "$OUTPUT_FILE"
