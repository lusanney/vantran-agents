# MCP Server Setup on Coder Devbox

How to set up remote MCP servers on a Coder devbox for Claude Code. All remote
servers use `mcp-remote` as a stdio bridge with OAuth via port forwarding.

## Port Allocation

| Server | Port | URL |
|--------|------|-----|
| Glean | 18083 | `https://canva-prod-be.glean.com/mcp/default` |
| Sourcegraph | 18084 | `https://canva.sourcegraphcloud.com/.api/mcp` |
| Sourcegraph DeepSearch | 18085 | `https://canva.sourcegraphcloud.com/.api/mcp/deepsearch` |
| Atlassian (canva) | 18086 | `https://mcp.atlassian.com/v1/mcp` |
| Atlassian-dev (canvadev) | 18087 | `https://mcp.atlassian.com/v1/mcp?site=canvadev` |
| Canva | 18088 | `https://mcp.canva.com/mcp` |

## Prerequisites

- Coder devbox with Claude Code (`otter claude-code`)
- Local Mac with `coder` CLI installed
- Config location: `~/.config/otter/claude-code-user/.claude.json` (NOT `~/.claude/`)

## Setup (per server)

Each server is a 3-step process: register, port-forward, authenticate.

### Step 1 — Register on devbox

```bash
CLAUDE_CONFIG_DIR=~/.config/otter/claude-code-user claude mcp add -s user <name> -- \
  npx -y mcp-remote <url> <port> --allow-http
```

### Step 2 — Port forward from local Mac

```bash
coder port-forward <workspace> --tcp <port>:<port>
```

### Step 3 — Authenticate on devbox (separate terminal)

```bash
npx -y mcp-remote@latest <url> <port> --allow-http
```

Click the auth link, complete OAuth in browser, Ctrl+C when done.

## Full Registration Commands

```bash
# Glean
CLAUDE_CONFIG_DIR=~/.config/otter/claude-code-user claude mcp add -s user glean -- \
  npx -y mcp-remote https://canva-prod-be.glean.com/mcp/default 18083 --allow-http

# Sourcegraph
CLAUDE_CONFIG_DIR=~/.config/otter/claude-code-user claude mcp add -s user sourcegraph -- \
  npx -y mcp-remote https://canva.sourcegraphcloud.com/.api/mcp 18084 --allow-http

# Sourcegraph DeepSearch
CLAUDE_CONFIG_DIR=~/.config/otter/claude-code-user claude mcp add -s user sourcegraph-deepsearch -- \
  npx -y mcp-remote https://canva.sourcegraphcloud.com/.api/mcp/deepsearch 18085 --allow-http

# Atlassian (canva.atlassian.net)
CLAUDE_CONFIG_DIR=~/.config/otter/claude-code-user claude mcp add -s user atlassian -- \
  npx -y mcp-remote https://mcp.atlassian.com/v1/mcp 18086 --allow-http

# Atlassian-dev (canvadev.atlassian.net) — query param makes cache distinct
CLAUDE_CONFIG_DIR=~/.config/otter/claude-code-user claude mcp add -s user atlassian-dev -- \
  npx -y mcp-remote "https://mcp.atlassian.com/v1/mcp?site=canvadev" 18087 --allow-http

# Canva (designs, docs)
CLAUDE_CONFIG_DIR=~/.config/otter/claude-code-user claude mcp add -s user canva -- \
  npx -y mcp-remote https://mcp.canva.com/mcp 18088 --allow-http
```

## Port Forwarding (all at once)

```bash
coder port-forward <workspace> \
  --tcp 18083:18083 \
  --tcp 18084:18084 \
  --tcp 18085:18085 \
  --tcp 18086:18086 \
  --tcp 18087:18087 \
  --tcp 18088:18088
```

## Token Persistence

OAuth tokens are cached in `~/.mcp-auth/mcp-remote-<version>/` on the devbox,
keyed by MD5 hash of the URL. Tokens persist across devbox restarts (EBS-backed
home dir).

**Port forwarding is NOT needed day-to-day.** On startup, mcp-remote refreshes
tokens via HTTP (no browser). Port forwarding is only needed for:
- First-time OAuth setup
- Refresh token expiry (weeks/months)
- Clearing `~/.mcp-auth/`

## Gotchas

### Atlassian dual-domain

Both `atlassian` and `atlassian-dev` point to the same base URL. The `?site=canvadev`
query param gives them different cache hashes so tokens don't overwrite each other.
If one breaks after the other re-auths, re-auth the broken one on its port.

### Port collisions

Each mcp-remote instance must have its own port. If two servers share a port,
OAuth state mismatches (CSRF errors) will occur.

### Config directory

Otter's Claude Code uses `~/.config/otter/claude-code-user/` not `~/.claude/`.
Always set `CLAUDE_CONFIG_DIR` when using `claude mcp add`.

### Stale npx cache

If mcp-remote ignores the port argument, clear the npx cache:
```bash
rm -rf ~/.npm/_npx/
```
