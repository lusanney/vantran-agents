#!/usr/bin/env bash
# sync-setup.sh — Pull latest config on other machines.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
CLAUDE_DIR="${HOME}/.claude"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()  { echo -e "${GREEN}[sync-setup]${NC} $*"; }
warn() { echo -e "${YELLOW}[sync-setup]${NC} $*"; }
err()  { echo -e "${RED}[sync-setup]${NC} $*"; }

cd "$REPO_DIR"

find "${SCRIPT_DIR}" -name '*.sh' -exec chmod +x {} +

if ! git diff --quiet || ! git diff --cached --quiet; then
  warn "Uncommitted local changes — skipping pull."
  exit 1
fi

log "Fetching origin/main..."
git fetch origin main --quiet

LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [ "$LOCAL" = "$REMOTE" ]; then
  log "Already up to date."
  exit 0
fi

if ! git merge-base --is-ancestor HEAD origin/main; then
  err "Local and remote have diverged — manual intervention required."
  exit 1
fi

log "Merging origin/main (fast-forward)..."
git merge --ff-only origin/main

find "${SCRIPT_DIR}" -name '*.sh' -exec chmod +x {} +

log "Verifying symlinks..."
for path in \
  "${CLAUDE_DIR}/settings.json" \
  "${CLAUDE_DIR}/rules" \
  "${CLAUDE_DIR}/skills/canva-coding" \
  "${CLAUDE_DIR}/skills/canva-code-review"; do
  if [ -L "$path" ] && [ -e "$path" ]; then
    echo "  ✓ $path"
  elif [ -L "$path" ]; then
    warn "  ! $path (broken symlink) — run install.sh"
  else
    warn "  ! $path (missing) — run install.sh"
  fi
done

log "Sync complete."
