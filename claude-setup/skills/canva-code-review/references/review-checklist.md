# Code Review Checklist

## Correctness

- [ ] Logic matches stated intent from PR description and Jira ticket
- [ ] Null handling explicit — `Preconditions.checkNotNull()`, `@Nullable`
- [ ] Error paths return meaningful errors
- [ ] Race conditions considered for shared mutable state
- [ ] Transaction boundaries correct
- [ ] Proto field numbers unique and not reused
- [ ] Backwards compatibility — old clients still work

## Code Quality (Canva Java)

- [ ] 2-space indentation, 100 char line limit
- [ ] `var` where type obvious, explicit req/res variables for service calls
- [ ] `Preconditions`/`Verify` over `assert`
- [ ] Java 9+ `List.of()`, `Set.of()` over Guava
- [ ] `CompletableFutures.combine()` over `allOf()`
- [ ] Repository: single statement, record-only, no business logic
- [ ] Generated files not hand-edited

## Security

- [ ] Auth checks present — `AdminRoleHelper`, `SourcePolicy`
- [ ] New RPC endpoints have appropriate `SourcePolicy`
- [ ] User input validated at system boundaries
- [ ] No SQL injection, command injection, XSS
- [ ] PII not logged, secrets not hardcoded

## Performance

- [ ] No N+1 queries, no unbounded collections
- [ ] Appropriate indexes, pagination for list operations
- [ ] Timeouts on all external calls
- [ ] Long-running operations in workers, not RPC handlers

## Test Coverage

- [ ] Unit tests for new/changed behavior
- [ ] Edge cases and error paths tested
- [ ] Test fakes updated (`Fake*Client.java`)
- [ ] Deploy tests considered for critical paths

## Module Wiring

- [ ] Guice modules bind new dependencies
- [ ] Feature flags with correct defaults
- [ ] RPC router, HTTP router, timeout provider, throttle wrapper updated
