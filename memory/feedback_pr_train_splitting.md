---
name: PR train splitting strategy
description: Split PRs by logical functionality, not by class/file
type: feedback
---

Split PRs by logical functionality, not by class/file. Each PR should be a reviewable, self-contained unit.

**Why:** Joel flagged that splitting a new class, its abstract method change, and its wiring into 3 separate PRs made each one hard to review in isolation.

**How to apply:** Group by "what does this enable" not "what file does this touch." A PR should compile AND make sense by itself.
