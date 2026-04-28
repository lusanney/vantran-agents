---
name: canva-coding
description: Use when writing, modifying, or reviewing backend code in the Canva monorepo. Covers Java backend services, Bazel builds, MySQL/jOOQ, DynamoDB, protocol buffers, testing patterns, and PR conventions. Triggers include any Canva backend work, service implementation, PR preparation, code review, debugging Canva services, working with protos, or following Canva's engineering standards.
---

# Canva Coding Skill

Canva's authoritative coding standards for backend development.

## Critical First Steps

Before any code work, check these locations in order:
1. **Service-specific**: `<service_name>/AGENT.md` or `CLAUDE.md` or `AGENTS.md`
2. **Cursor rules**: `.cursor/rules/java-conventions.mdc`, `.cursor/rules/pull-request-conventions.mdc`
3. **SQL definitions**: `production/bin/sql/create_<table>.sql`
4. **Engineering Handbook**: `docs.canva.tech/common/style-guides/`

## Universal Style Foundation

**Naming**:
- Things (classes/types): noun phrases → `UserAccount`, `DeletionResult`
- Actions (methods): verb phrases → `processData()`, `validateInput()`
- Files: Java=PascalCase, others=kebab-case or snake_case

**Formatting**:
- **2-space indentation** (not 4)
- **100 char line limit** - wrap with double indentation
- Base: Google Java Style Guide with Canva overrides

## Java Standards (Java 17+)

### Variable Declaration & Service Calls
```java
// ✅ GOOD - Explicit request/response variables
var req = GetUserRequest.builder(...).build();
var res = profile.getUser(ctx, req);
var user = res.user;

// ❌ BAD - Inline service call
User user = profile.getUser(ctx, GetUserRequest.builder(...).build()).user;
```

### Error Handling
```java
Preconditions.checkNotNull(user, "User cannot be null");
Preconditions.checkArgument(user.isValid(), "User must be valid");
var result = externalService.process(user);
Verify.verify(result != null, "Service should never return null");

if (input == null) { return null; }
```

### Modern Java Features
- `var` when type is obvious from initialization
- Switch expressions with exhaustiveness
- Pattern matching: `if (obj instanceof String s)`
- Records for immutable data
- Classes final by default

### Collections & Streams
- Prefer Java 9+ `List.of()`, `Set.of()`, `Map.of()` over Guava
- Use Guava only when iteration order matters or builders needed
- Streams only when clear advantage; imperative is first-class
- `forEach` only for side effects

### CompletableFuture
```java
// ✅ Use Canva's helper
CompletableFutures.combine(future1, future2, (r1, r2) -> processResults(r1, r2));

// ❌ Don't use allOf
CompletableFuture.allOf(future1, future2)  // Error-prone
```

## Forbidden Practices

**Never use**:
- `assert` statements (disabled in production)
- Apache Commons (except commons-cli)
- `final` on local variables
- Generic `FooConstants` classes
- Default cases in exhaustive enum switches
- `CompletableFuture.allOf()` - use `CompletableFutures.combine()`
- Blocking operations in reactive chains
- Business logic in DTOs or repositories
- String concatenation for SQL (SQL injection risk)

## Repository Pattern

Each repository method: **single statement**, **record-only mapping**, **no business logic**.

```java
public class AppRepository {
    public Optional<AppRecord> getAppById(String appId) {
        return dsl.selectFrom(APP).where(APP.APP_ID.eq(appId)).fetchOptional();
    }
}

public class AppMapper {
    public App recordToApp(AppRecord record) { ... }
}
```

## MySQL & jOOQ

See `references/mysql-jooq-patterns.md` for complete patterns.

**Table definitions** live in `production/bin/sql/create_<service>.sql`.

**Key rules**:
- Always use parameterized queries (prevent SQL injection)
- Single SQL statement per repository method
- Record-only mapping in repositories
- Separate mapper classes for business object conversion

```bash
tools/jooq/jooq-codegen.sh <service>_server
```

## DynamoDB Patterns

See `references/dynamodb-patterns.md` for complete patterns.

## Protocol Buffers

**Never modify generated code** - files marked `@Generated` are regenerated.

```bash
./bin/regen_protos.sh -i <proto_file>
```

## Testing

See `references/testing-patterns.md` for complete patterns.

**Test organization**:
- Unit tests: `*Test.java`, tags `["unit", "block-network"]`
- Integration tests: `*IntegrationTest.java`, tags `["integration"]`

**Key principles**:
- Prefer fakes over mocks: `FakeFlags`, `FakeClock`
- MC-FIRE: Maintainable, Concise, Fast, Isolated, Repeatable, Expressive
- AAA pattern: Arrange, Act, Assert

## Build & Commands

```bash
bazel build //<service>:all
taz fmt
taz lint --skip-tasks sonarlint --skip-tasks semgrep
taz check
```

## PR Conventions

**Title format**: `[JIRA-999] <description>` or `<scope>: <description> [JIRA-999]`

**Before PR**:
```bash
taz check && bazel test //<service>/... && taz fmt
```

## Feature Flags

```java
static final ConfigFlag<Boolean> MY_FLAG =
    Flags.configFlag("serviceNameMyFlag", false);
```

## Service Structure

```
<service>_server/
├── src/main/java/com/canva/<service>/
│   ├── api/           # Generated proto definitions
│   ├── server/        # Core implementation
│   │   ├── db/        # Database layer
│   │   │   └── repository/
│   │   └── worker/    # Background processing
│   └── rpc/           # RPC handlers
├── src/test/          # Tests
└── BUILD.bazel
```

## Worker & Background Tasks

See `references/worker-patterns.md` for complete patterns including CDC.

## Deploy Tests

See `references/deploy-tests-patterns.md` for complete patterns.

## Quick Reference

| Task | Command |
|------|---------|
| Build | `bazel build //<service>:all` |
| Unit tests | `bazel test //<service>:unit-tests` |
| Integration tests | `bazel test //<service>:integration-tests` |
| Format | `taz fmt` |
| Lint | `taz lint` |
| Pre-commit | `taz check` |
| Regen protos | `./bin/regen_protos.sh -i <proto>` |
| Regen jOOQ | `tools/jooq/jooq-codegen.sh <service>_server` |
| SQL definitions | `~/production/bin/sql/create_<table>.sql` |
