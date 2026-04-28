# Deploy Tests at Canva

Deploy tests run against new releases **before production traffic**. They gate deployments.

## Key Properties

- Run prior to scaling up
- Run as your service identity
- 10-minute timeout
- Any failure blocks deployment and triggers rollback

## Structure

```
<service>_server/
├── src/test/java/com/canva/<service>/server/deploy/
│   ├── rpc/
│   │   ├── FooRpcDeployTest.java
│   │   └── FooRpcDeployTestModule.java
│   └── worker/
└── src/test/resources/META-INF/deploy_test/
```

## Annotations

```java
@Test
@DeployTest(maxAttempts = 2, retryDelayMillis = 1000)
@RunOn(flavor = "dev")
@RunOn(flavor = "staging")
@RunOn(flavor = "prod")
public void testCriticalEndpoint() { ... }
```

## Testing with Devpod

```bash
infra devpod create --name foo-rpc --target dev \
    --bazel-target //backend/foo_rpc/deploy_tests:deploy-tests-container --deploy-test
```

## Best Practices

- Keep tests high-level
- Use 2 retries by default
- Be idempotent
- Keep under 10 minutes
- Use `dryRun` for new tests
