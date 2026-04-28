# Claude Code Setup

Version-controlled Claude Code configuration for `~/.claude/`. The repo holds the
actual files; `~/.claude/` entries are symlinks into this directory.

## What's backed up

| `~/.claude/` entry | Method |
|---|---|
| `settings.json` | symlink |
| `rules/` | symlink |
| `skills/canva-coding/` | symlink |
| `skills/canva-code-review/` | symlink |

**Not backed up:** `projects/`, `history.jsonl`, session transcripts, transient state.

## First-time setup

```bash
git clone https://github.com/canvanauts/vantran-agents.git ~/work/vantran-agents
bash ~/work/vantran-agents/claude-setup/install.sh
```

`install.sh` is idempotent: re-running it backs up conflicting files as `.bak`.

## Pushing changes

```bash
~/work/vantran-agents/claude-setup/push-setup.sh
# or with a custom message:
~/work/vantran-agents/claude-setup/push-setup.sh "feat: add new rule"
```

## Pulling changes (other machines)

```bash
~/work/vantran-agents/claude-setup/sync-setup.sh
```

## Auto-sync via cron

```
*/15 * * * * /home/coder/work/vantran-agents/claude-setup/sync-setup.sh >> /home/coder/.claude/sync.log 2>&1
```
