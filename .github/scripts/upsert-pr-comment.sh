#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-}"
PR_NUMBER="${2:-}"
MARKER="${3:-}"
BODY_FILE="${4:-}"

if [ -z "$REPO" ] || [ -z "$PR_NUMBER" ] || [ -z "$MARKER" ] || [ -z "$BODY_FILE" ]; then
  echo "usage: $0 <repo> <pr-number> <marker> <body-file>" >&2
  exit 1
fi

if [ ! -f "$BODY_FILE" ]; then
  echo "body file not found: $BODY_FILE" >&2
  exit 1
fi

gh api "repos/$REPO/issues/$PR_NUMBER/comments" --paginate > /tmp/pr-comments.json

COMMENT_ID=$(jq -r --arg marker "$MARKER" '
  [.[] | select(.user.login == "github-actions[bot]") | select(.body | contains($marker)) | .id] | first // empty
' /tmp/pr-comments.json)

if [ -n "$COMMENT_ID" ]; then
  jq -n --rawfile body "$BODY_FILE" '{body:$body}' > /tmp/comment-payload.json
  gh api --method PATCH "repos/$REPO/issues/comments/$COMMENT_ID" --input /tmp/comment-payload.json > /dev/null
else
  gh pr comment "$PR_NUMBER" --repo "$REPO" --body-file "$BODY_FILE" > /dev/null
fi
