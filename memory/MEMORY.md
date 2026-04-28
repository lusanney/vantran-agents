# Canva Monorepo Memory

## app_server Patterns

### Adding a new RPC endpoint (the full chain)
To add `fooAction` to app_server, touch ALL of these files:
1. `protos/src/main/proto/services/app/app_v2.proto` — message types
2. `protos/src/main/proto/services/app/app.proto` — service RPC declaration
3. `protos/src/main/proto/services/app/app_api.proto` — HTTP route (if public)
4. `protos/src/main/proto/services/app/app_event.proto` — event types (if publishing events)
5. Run `./bin/regen_protos.sh -i app` to regenerate `AppV2Proto.java` + TS bindings
6. `app_client/src/main/java/com/canva/app/AppService.java` — interface method
7. `app_client/src/main/java/com/canva/app/AppServiceAsync.java` — async interface
8. `app_client/src/main/java/com/canva/app/client/AppProtoClient.java` — client impl
9. `app_client/src/test/java/com/canva/app/client/FakeAppClient.java` — fake
10. `app_server/src/main/java/com/canva/app/api/AppApi.java` — HTTP API interface
11. `app_server/src/main/java/com/canva/app/api/AppApiHandler.java` — HTTP handler
12. `app_server/src/main/java/com/canva/app/api/AppApiRouter.java` — HTTP route
13. `app_server/src/main/java/com/canva/app/api/AppApiTimeoutProvider.java` — timeout
14. `app_server/src/main/java/com/canva/app/server/AppRpcRouter.java` — gRPC route
15. `app_server/src/main/java/com/canva/app/server/AppServiceServer.java` — delegation
16. `app_server/src/main/java/com/canva/app/server/throttle/ThrottledAppService.java` — throttle
17. `app_server/src/main/java/com/canva/app/server/v2/rpc/AppV2Service.java` — core logic
18. `catchall_frontend/src/main/resources/apiz/AppApi.yaml` — OpenAPI spec

### Admin/private endpoints
- No separate port/service — gates are: (a) SourcePolicy allowlist in AppRpcModule, (b) AdminRole check inside handler
- `AdminRoleHelper.getAdminRole(ctx)` checks `StaffGroups.APP_ADMINS` membership

### Event publishing (transactional outbox)
- `AppNotificationPublisher` writes event records within the same transaction
- `AppEventDriver` (worker, ZK-coordinated) delivers events to SNS

## Git Worktree Convention

```
git worktree add ~/work/canva-worktrees/<branch-name> -b <branch-name>
```

## Key File Locations

- Proto files: `protos/src/main/proto/services/app/`
- DB schema: `production/bin/sql/create_app.sql`
- App admin check: `app_server/.../v2/admin/AdminRoleHelper.java`

## Atlassian MCP Server Mapping

- **`atlassian`** → `canva.atlassian.net` (production Jira/Confluence)
- **`atlassian-dev`** → `canvadev.atlassian.net` (dev Jira/Confluence)

## Code Review Patterns

- **Mechanical propagation PRs** — use checklist-based review
- See `review-patterns.md` for full propagation manifests and known pitfalls
- See `patterns.md` for EDGE/Cloudflare, Smartling, ErrorProne, Platy patterns
- See `review-bazel-container-migration.md` for Bazel container migration checklist

## PR Train Best Practices
- [PR train splitting strategy](feedback_pr_train_splitting.md)

## Formatting & CI
- [Always run taz fmt before commits/PRs](feedback_taz_fmt_before_commit.md)
