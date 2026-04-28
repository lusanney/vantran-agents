#!/usr/bin/env bash
# review-pr.sh — Invoke canva-code-review skill via Claude CLI.
# Usage:
#   ./review-pr.sh https://github.com/Canva/canva/pull/850769
#   ./review-pr.sh 850769

set -euo pipefail

PR_INPUT="${1:?Usage: review-pr.sh <PR_URL_or_NUMBER>}"

if [[ "$PR_INPUT" =~ ^[0-9]+$ ]]; then
  PR_URL="https://github.com/Canva/canva/pull/${PR_INPUT}"
else
  PR_URL="$PR_INPUT"
fi

echo "/canva-code-review ${PR_URL}" | otter claude-code -p
