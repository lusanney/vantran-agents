---
name: canva-code-review
description: >
  This skill should be used when the user asks to "review a PR", "review pull request",
  "code review", "check this PR", "review PR #N", "review https://github.com/Canva/canva/pull/N",
  or provides a GitHub PR URL for review. Also triggers on "what do you think of this PR",
  "is this PR ready to merge", "review the diff", or any request to evaluate code changes
  in the Canva monorepo. Use this skill proactively whenever a PR URL is provided,
  even if the user doesn't explicitly say "review".
---

# Canva Code Review

Structured protocol for reviewing GitHub PRs in the Canva monorepo. Combines procedural
pattern detection with deep review of custom logic, security, performance, and architecture.

## Invocation

```
/canva-code-review https://github.com/Canva/canva/pull/850769
```

## Phase 0: PR Intake

1. Fetch PR metadata via `get_pull_request` — note title, author, labels, draft status, base branch.
2. Read the description. Extract:
   - **Jira ticket(s)** — fetch via `jira-get-issue` for requirements and acceptance criteria.
   - **Canva design doc links** — fetch via Canva MCP or `WebFetch`.
   - **Docs links** (`docs.canva.tech`) — fetch via `kb_fetch`.
   - **Slack threads** — search via Glean.
   - **Stated assumptions and performance claims** — record for fact-checking in Phase 4.
3. Check existing reviews via `get_pull_request_reviews` and `get_pull_request_comments`.
4. Check CI/build status via `get_pull_request_status`.

## Phase 1: Classification & Verification Plan

### 1a. Classify the PR

Fetch file list via `get_pull_request_files`. Classify:

| Category | Signal | Strategy |
|----------|--------|----------|
| **Purely procedural** | All files match known pattern; no custom logic | Checklist-verify only |
| **Mixed** | Some procedural, some custom logic | Checklist for procedural; deep review for custom |
| **Custom** | Mostly novel code, architecture changes | Full deep review |

**Procedural files**: content fully determined by pattern — generated code, proto enum additions, mapper switch cases, test fakes with UnsupportedOperationException stubs.

**Custom logic files**: author made a decision — business logic, feature flag gating, security checks, error handling, test assertions for custom behavior.

### 1b. Check Known Patterns

Check if file list matches known patterns from `memory/review-patterns.md`:
- **Add OAuth Permission Scope** — ~30-40 files across proto, generated Java/TS, mappers, OpenAPI, TS utils
- **Add Manifest Intent** — proto, JSON schema, manifest model, OpenAPI, web UI, fakes, fixtures
- **Add RPC Endpoint** — proto, generated code, client, fake, handler, router, timeout, throttle

## Phase 2: Diff Review

Fetch diff via `get_pull_request_diff`.

**For large PRs (>10 files or >500 lines):** Spawn parallel agents by domain.

### 2a. Procedural Verification

Verify mechanically against pattern checklist: completeness, consistency, generated files not hand-edited, known pitfalls.

### 2b. Custom Logic Deep Review

Apply full checklist from `references/review-checklist.md`: correctness, security, performance, test coverage.

### 2c. Boundary Files

Files straddling procedural/custom deserve extra scrutiny — bugs hide at pattern boundaries.

## Phase 3: Architecture & Context

Use Sourcegraph and Glean for broader understanding:
- Trace call chains and impact radius
- Check for past discussions and decisions
- Verify patterns against similar PRs

## Phase 4: Fact-Checking

See `references/fact-checking.md`. Verify: feature flags, infrastructure config, performance claims, API contracts.

## Phase 5: Reasoning Check

For significant design decisions in custom logic: why this choice? tradeoffs? right layer? conditional dependencies enforced?

## Phase 6: Verification & Synthesis

1. Compare implementation against Phase 1 verification plan.
2. Classify findings: **Blocking**, **Non-blocking**, **Questions**, **Risks**.
3. Clear verdict: approve, request changes, or comment-only.

## Additional Rules

- Check file ownership, flag cross-team changes.
- Flag accidental inclusions (debug logs, unrelated formatting).
- For draft PRs, focus on architecture over polish.
- Note new procedural patterns for codification.
