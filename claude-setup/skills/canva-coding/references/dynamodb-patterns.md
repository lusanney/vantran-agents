# DynamoDB Patterns at Canva

## API Choice

- **Version 2 (preferred)**: `DynamoDbEnhancedClient`
- **Version 1 (legacy)**: `DynamoDBMapper`
- **Low-level API**: Only for complex queries

## DTO Standards

```java
@DynamoDbImmutable(builder = BarDto.class)
@DynamoDBV2TableName(value = "bar-items", overrideFlag = "barItemsTableOverride")
public class BarDto {
    // Package private constructor, use builder
    // DTO class suffixed with "Dto"
    // NO LOGIC — only data
}
```

## Repository Pattern

Single DynamoDB action per method, non-static methods, DTO-only mapping.

## Optimistic Locking

```java
@DynamoDBVersionAttribute
private Long version;
```

## Transaction Best Practices

- Always set idempotency tokens on transactional writes
- Use `ConditionalCheckRetry` utility
- One transaction per service method
- Prefer conditional updates over transactions when possible

## Anti-Patterns

- Logic in DTO classes
- Missing idempotency tokens on transactional writes
- Using low-level API for simple CRUD
- Multiple DynamoDB actions per repository method
