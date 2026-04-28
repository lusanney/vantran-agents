---
name: No single subagent blocking
description: Never spawn exactly 1 subagent and wait — do the work on the main thread instead
type: feedback
---

Never spawn a single subagent and block waiting for it.

**Why:** 1 agent = zero parallelism + overhead. Main thread (Opus 4.6 1M) is faster.

**How to apply:** Before spawning agents, ask: "Am I spawning 2+ in parallel?" If no, do it yourself.
