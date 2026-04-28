---
name: Always run taz fmt before commits and PRs
description: Run taz fmt before git commit or PR creation to avoid Buildkite formatting failures
type: feedback
---

Always run `taz fmt` on changed files before committing or creating a PR.

**Why:** PRs consistently fail formatting checks on Buildkite without it.

**How to apply:** Before any `git commit` or PR creation, run `taz fmt`. For thorough check: `taz check --silent`.
