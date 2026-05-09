# Apple Watch Assistant BRD Update - 2026-04-27 10:31:00 UTC

## Priority

- Priority: P0
- PM/Telegram role = audit/co-ordination only
- Codex IDE in VS Code = technical executor

## Minh Decision Approved

Architecture v0.1 is approved as the baseline for Apple Watch Assistant MVP.

This means execution does **not** need to wait for a future final architecture before continuing.

## Execution Split

### P0a - Execute now on Linux/VPS

Allowed to continue immediately:
- backend/mock/skeleton
- API contract
- runtime isolation for Apple Watch assistant path
- logging/session path setup
- dashboard project visibility and evidence plumbing

### P0b - Input Required for real Apple build/distribution

Separate input-required track only:
- watchOS simulator build on Mac/Xcode runner
- real device signing
- TestFlight path
- Apple Developer account / Team ID / Bundle ID / provisioning / certificate authority

## Blocker Reclassification

- Architecture v0.1 is **not** a RED blocker anymore.
- Mac/Xcode/signing is **not** a blocker for the whole Apple Watch project.
- Signing is only `Input Required` for real device/TestFlight execution.
- Apple Watch progress must not stay `0/8` if BRD/architecture/runtime/signing artifacts already exist with real evidence.

## PM Audit Rules

- Do not report `GREEN`, `done`, or `xong` without live evidence.
- Task `done` still requires concrete evidence.
- Dashboard alerts must not stay stale after this decision.

## Required Dashboard Effect

Dashboard should reflect:
- architecture v0.1 accepted as baseline
- signing shown as `Input Required` for real device/TestFlight only
- Apple Watch progress derived from real source-of-truth artifacts already created

## Evidence

- Minh decision received via Telegram at 2026-04-27 10:31 UTC.
- Existing artifacts already present under project folder:
  - `brd/100825_27042026_apple-watch-assistant.md`
  - `architecture/100825_27042026_apple-watch-assistant-architecture.md`
  - `decisions/100825_27042026_runtime-unblock-decision.md`
  - `signing/100825_27042026_signing-path.md`
  - `runtime/100825_27042026_runtime-isolation.md`
