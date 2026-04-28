# MySQL & jOOQ Patterns at Canva

## Table Definitions

For App Services, SQL table definitions are in:
```
~/production/bin/sql/create_<table_name>.sql
```

Examples:
- `~/production/bin/sql/create_app.sql`
- `~/production/bin/sql/create_app_oauth_credential.sql`
- `~/production/bin/sql/create_ecosystem-integration.sql`

Always check these files to understand table schema before writing queries.

## jOOQ Code Generation

```bash
tools/jooq/jooq-codegen.sh <service>_server
```

**Never modify generated jOOQ files** — they are overwritten during regeneration.

## Repository Pattern Requirements

1. **Single SQL statement per method**
2. **Non-static methods** — for unit testing
3. **Record-only mapping** — no mapping to non-record types
4. **No business logic**

## Query Patterns

### Parameterized Queries (Required)
```java
// ✅ GOOD
public List<AppRecord> getAppsByStatus(String status) {
    return dsl.selectFrom(APP).where(APP.STATUS.eq(status)).fetch();
}

// ❌ BAD — SQL injection risk
return dsl.fetch("SELECT * FROM app WHERE status = '" + status + "'");
```

### Separate Mapper for Business Objects
```java
public class AppMapper {
    public App recordToApp(AppRecord record) {
        return App.builder()
            .appId(record.getAppId())
            .name(record.getName())
            .build();
    }
}
```

## Anti-Patterns

- String concatenation for SQL queries
- Business logic in repository methods
- Mapping to non-record types in repository methods
- Static repository methods
- Multiple SQL statements per method
- Unbounded queries without limits
