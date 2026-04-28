#!/usr/bin/env bash
# install.sh — Set up ~/.claude/ symlinks into this repo's claude-setup directory.
# Idempotent: safe to re-run.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { echo -e "${GREEN}[install]${NC} $*"; }
warn() { echo -e "${YELLOW}[install]${NC} $*"; }

# Ensure all .sh scripts are executable
find "${SCRIPT_DIR}" -name '*.sh' -exec chmod +x {} +

make_symlink() {
  local target="$1"
  local link="$2"

  if [ -L "$link" ]; then
    if [ "$(readlink "$link")" = "$target" ]; then
      log "Already linked: $link"
      return
    else
      warn "Replacing wrong symlink: $link → $(readlink "$link")"
      rm "$link"
    fi
  elif [ -e "$link" ]; then
    warn "Backing up existing $link → ${link}.bak"
    mv "$link" "${link}.bak"
  fi

  ln -sf "$target" "$link"
  log "Linked: $link → $target"
}

mkdir -p "${CLAUDE_DIR}"

# --- Top-level symlinks ---
make_symlink "${SCRIPT_DIR}/settings.json"    "${CLAUDE_DIR}/settings.json"
make_symlink "${SCRIPT_DIR}/rules"            "${CLAUDE_DIR}/rules"

# --- Skills ---
mkdir -p "${CLAUDE_DIR}/skills"
make_symlink "${SCRIPT_DIR}/skills/canva-coding"        "${CLAUDE_DIR}/skills/canva-coding"
make_symlink "${SCRIPT_DIR}/skills/canva-code-review"   "${CLAUDE_DIR}/skills/canva-code-review"

# --- Verification ---
echo ""
log "Verification:"
for path in \
  "${CLAUDE_DIR}/settings.json" \
  "${CLAUDE_DIR}/rules" \
  "${CLAUDE_DIR}/skills/canva-coding" \
  "${CLAUDE_DIR}/skills/canva-code-review"; do
  if [ -L "$path" ]; then
    echo "  ✓ $path → $(readlink "$path")"
  elif [ -e "$path" ]; then
    echo "  ~ $path (not a symlink)"
  else
    echo "  ✗ $path (missing)"
  fi
done
echo ""
log "Done. Claude Code config is now managed from: ${SCRIPT_DIR}"
