---
name: Bazel Container Migration Review Pattern
description: Checklist for reviewing PRs that migrate test containers from fromProperty/tarball to fromTarget/oci_image
type: feedback
---

When reviewing Bazel test container migrations (fromProperty → fromTarget):

1. Verify `oci_image` targets pre-exist with `//visibility:public`
2. Search for zero remaining old-pattern refs scoped to the migrated container type
3. Confirm `testcontainers.properties` deleted
4. Check for orphaned `:tarball` filegroup targets
5. Failure mode is always loud — `fromTarget` with bad target fails at Bazel analysis time

Two categories:
- **Infrastructure containers** (redis, mysql, dynamodb, etc.) — shared images, migrated
- **Service-level containers** (~15 services) — still on `fromProperty`, separate scope
