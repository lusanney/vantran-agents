# Worker Patterns at Canva

## LeaderTask & LeaderTaskRunner

LeaderTask uses ZooKeeper for leader election — only one instance runs at a time.

```java
public class MySweeperTask implements LeaderTask {
    @Override
    public boolean run() throws Exception {
        var items = repository.findItemsToProcess(BATCH_SIZE);
        if (items.isEmpty()) { return false; }
        processItems(items);
        return true;
    }
}
```

### LeaderTaskRunner Setup

```java
@Bean("myLeaderTaskRunner")
public LeaderTaskRunner myLeaderTaskRunner(CuratorFramework curator, MySweeperTask task) {
    return LeaderTaskRunner.builder(curator, "/my-service/my-task", task, "my-task")
        .withDelayMs(TimeUnit.MINUTES.toMillis(5))
        .build();
}
```

**Naming**: `*Sweeper` (collects), `*Driver` (creates), `*Reaper` (terminates)

## DataProcessingLeaderTask (Backfills)

Handles state management, continuation tokens, and chunked processing.

States: `CREATED` → `IN_PROGRESS` → `COMPLETED`

Requires: `TaskDataReader` (reads batches), `ZookeeperTaskStateStorage` (persists state)

## CDC (Change Data Capture)

```
RDS MySQL → DMS (CDC) → Kinesis Data Stream → Kinesis Firehose → S3 → Snowflake
```

Infrastructure: `infrastructure/common/data-platform/data-extraction/blueprints/rds-mysql-s3/`
