# Review Patterns: Mechanical Propagation PRs

## Pattern: Add OAuth Permission Scope

**Detection signal:** PR touches 25-40 files across proto/, *Proto.java, *_proto.ts, OpenAPI YAML, mapper Java files, TS utils, and messages.ts.

### Propagation Manifest

1. **Proto Definitions (5 files)** — PermissionV1 enum across 5 proto files. Check: field number unique, sequential, same across all files.
2. **Generated Java (5 files)** — Confirm regenerated, not hand-edited. Serialization value matches proto.
3. **Generated TS (~4 files)** — Enum value matches proto.
4. **Java Mappers (HIGH RISK)** — `PermissionsMapper.java` has THREE switch methods with different return types. Known pitfall: `mapScope` returns `AppSearchProto.Permission.XXX` not `Permission.Scope.XXX`.
5. **OpenAPI Specs (4 YAML files)** — Obfuscated enum value is next letter in alphabetical sequence.
6. **TS Mappers & Utils** — New entries follow pattern of adjacent entries.
7. **UI Strings (messages.ts)** — Grammar matches sibling entries.
8. **Test Fakes** — Updated if scope list is hardcoded.

## Pattern: Add Manifest Intent

**Detection signal:** PR adds a new intent/activity to the app manifest. 25-40 files.

### Propagation Manifest

1. **Proto Definition** — New proto file + field in manifest proto.
2. **Generated Java** — `@Generated("com.canva.protogen")`, not hand-edited.
3. **JSON Schema** — New schema + reference in manifest.schema.json.
4. **Deserialized Model** — New model class + field in Activity.java.
5. **OpenAPI Spec** — New schema entry in AppApi.yaml.
6. **Public API Mapper** — BOUNDARY: verify null-mapping for internal-only intents.
7. **Web Frontend** — diff_view_config, intent_ui_utils, intents/create, preview.
8. **Test Fakes & Fixtures** — Fake data, test fixtures, web fakes.
9. **Tests** — Procedural tests + deep review for CustomValidations, AppV2Service, DeveloperManifestMapper.

### Deep review targets (custom logic)
- `CustomValidations.java` — dependency rules between intents
- `AppV2Service.java` — feature flag gating
- `DeveloperManifestMapper.java` — null-mapping for internal-only intents

## Pattern: TRUSTED_APP_IDS Allowlist

**Detection signal:** 1 file, +1 line in `TRUSTED_APP_IDS`.

Review checklist:
1. App ID format: 11 chars, lowercase
2. Inline comment identifies app name
3. Identity verification: does app ID belong to claimed owner?
