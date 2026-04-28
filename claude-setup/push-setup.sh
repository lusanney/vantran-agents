#!/usr/bin/env bash
# push-setup.sh — Commit and push changes to origin/main.
# Usage: ./push-setup.sh ["optional commit message"]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
COMMIT_MSG="${1:-chore: sync Claude Code config}"

GREEN='\033[0;32m'
NC='\033[0m'

log() { echo -e "${GREEN}[push-setup]${NC} $*"; }

cd "$REPO_DIR"

if git diff --quiet HEAD && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
  log "Nothing to push."
  exit 0
fi

log "Staging changes..."
git add -A

log "Committing: ${COMMIT_MSG}"
git commit -m "$COMMIT_MSG"

log "Pushing to origin/main..."
git push origin main

log "Done."
