# Fact-Checking Procedures

## Dynamic Config / Feature Flags

1. Local: `~/work/canva/dynamic-config` — grep for flag name, check per-flavor values
2. Sourcegraph: `keyword_search` for declaration and usage
3. Cross-reference: verify PR claims against actual values

## Infrastructure Config

1. Local: `~/work/canva/infrastructure` — K8s manifests, Terraform, Helm
2. Common assumptions to verify: HTTP idle timeouts, gRPC deadline propagation, connection pool sizes

## Performance Claims

1. Methodology: microbenchmark, load test, production trace?
2. Environment: dev/staging/prod?
3. Sample size and percentiles reported?
4. Red flags: dev-only benchmarks, single-run results, missing p95/p99

## API Contracts

1. Proto definitions: `protos/src/main/proto/services/<service>/`
2. Sourcegraph: `go_to_definition` to find server implementation
3. Verify: "field always populated" → check if required in proto

## Database Assumptions

1. Schema: `production/bin/sql/create_<service>.sql`
2. Table size: <1M rows regular ALTER fine; >10M consider ALGORITHM=INSTANT
3. Index coverage: verify WHERE clause matches index prefix
