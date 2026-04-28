# vantran-agents

Personal AI agent configuration — skills, project context, knowledge, and Claude Code setup.

Forked from [canvanauts/yunlong-agents](https://github.com/canvanauts/yunlong-agents).

## Structure

```
claude-setup/     ← Claude Code config (~/.claude/) — versioned and synced across machines
  install.sh        Set up symlinks on a new machine
  push-setup.sh     Commit and push config changes
  sync-setup.sh     Pull latest config (for cron on other machines)
  settings.json
  rules/
  skills/

skills/           ← Claude skills (reusable workflows)
  canva-coding/     Canva backend coding standards
  canva-code-review/ Structured PR review protocol

docs/             ← Knowledge base (reference documents)
  mcp-devbox-setup/ MCP server setup on Coder devbox

memory/           ← Canva monorepo memory (patterns, reviews, feedback)
```

## Claude Code setup (new machine)

```bash
git clone https://github.com/canvanauts/vantran-agents.git ~/work/vantran-agents
bash ~/work/vantran-agents/claude-setup/install.sh
```

See [`claude-setup/README.md`](claude-setup/README.md) for full details.

## MCP Devbox Setup

See [`docs/mcp-devbox-setup/README.md`](docs/mcp-devbox-setup/README.md) for setting up MCP servers on Coder devbox.
