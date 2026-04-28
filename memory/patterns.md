# Durable Patterns

## EDGE / Cloudflare Route Config Reviews

- 4-layer pipeline: Starlark DSL → generated JSON → generated TS → Cloudflare worker
- Implicit bucket convention: `bucketName` omitted = `url.host` fallback
- `proto2 optional` fields: `required → optional` is a meaningful wire-format change

## Smartling Translation Retrigger (Cop Duty Runbook)

Pipeline: Smartling → SPI webhook → SQS → SmartlingUpdateMessageHandler → upsert → status transition

SQS wire format: `{"A?":"A","A":"<locale>","B":"<file_uri>"}`

Key files:
- `SmartlingFileUpdateSpiHandler.java` — webhook handler
- `SmartlingUpdateMessageHandler.java` — worker
- `SmartlingConfig.java` — locale mapping (BiMap)

## app-rpc Source Policy Allowlist

File: `AppRpcModule.java` (~line 925-952). Binary access — on list = full access to all RPCs.

Review: alphabetical placement, rpc/worker pairing, actual need verification.

## ErrorProne / BUILD-* Reviews

- `MissingCasesInEnumSwitch:ERROR` + `UnnecessaryDefaultInEnumSwitch:ERROR` together
- Proto-generated enums include `UNRECOGNIZED`
- BUILD-978 is phased rollout across monorepo

## Platy / K8s Resource Config

- Source of truth: `backend/<component>/config/platy_intent.star`
- `select()` keys: default, dev, staging, staging_cn, prod, prod_cn
- Verify request AND limit coherence; check staging_cn sibling

## app_server Schema Migration Reviews

- jOOQ: check `@Generated`, verify ordinal alignment
- CDC fields (created_at/updated_at) always last in create_app.sql
- No separate ALTER TABLE migrations — create_*.sql is source of truth
- One-shot guard pattern: NULL = eligible, non-NULL = permanently excluded
