# Testing Patterns at Canva

## MC-FIRE: Maintainable, Concise, Fast, Isolated, Repeatable, Expressive

## Test Organization

- Unit tests: `*Test.java`, tags `["unit", "block-network"]`
- Integration tests: `*IntegrationTest.java`, tags `["integration", "hermetic"]`

## Fakes Over Mocks

```java
// ✅ GOOD
private final FakeFlags flags = new FakeFlags();
private final FakeClock clock = new FakeClock();

// ❌ BAD
@Mock private Flags flags;
```

Look for `@DoNotMock` annotation.

## AAA Pattern

```java
@Test
public void testUserCreation() {
    // Arrange
    var input = createTestInput();
    // Act
    var result = service.process(input);
    // Assert
    assertThat(result).isEqualTo(expected);
}
```

## Testcontainers

- `RpcTestContainer`, `WorkerTestContainer`, `FrontendTestContainer`
- `DependsOnS3`, `DependsOnDynamoDB`, `DependsOnMySQL` interfaces

## Bazel Targets

```bash
bazel test //<service>:unit-tests
bazel test //<service>:integration-tests
```
