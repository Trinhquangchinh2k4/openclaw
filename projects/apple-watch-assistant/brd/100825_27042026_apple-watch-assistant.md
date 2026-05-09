# Apple Watch Assistant BRD Update - 2026-04-27 10:08:25 UTC

## Priority

- Priority: P0.
- IDE/Codex 5.5 handles technical architecture, skeleton/backend mock, filesystem changes, and verification.
- Telegram PM is PM/auditor only.

## New Requirements

- Create a concrete architecture spec for watchOS, optional iPhone companion, backend assistant service, gateway/API, voice/STT/TTS, token/config storage, and dashboard monitoring.
- Split Mac/Xcode/signing path into:
  - simulator/dev path that does not block backend/mock/spec work;
  - real device/TestFlight path that requires Apple Developer account, Team ID, Bundle ID, signing certificate, provisioning, and TestFlight decisions.
- Gateway/session lock must not block the Apple Watch backend assistant path.
- Apple Watch path must use an isolated session/log path if the main OpenClaw session is locked.
- Backend/API/mock/spec work can continue on Linux/VPS even when Mac/Xcode is unavailable.

## Runtime Rule

- Apple Watch assistant requests must not acquire the `main` session write lock.
- If main session lock remains active, Apple Watch must use an isolated session id/path such as `apple-watch-assistant` plus separate logs under the project or agent path.
- Main session context may be consumed as read-only snapshot only when needed.

## Acceptance For This Update

- `architecture/100825_27042026_apple-watch-assistant-architecture.md` exists with v0.1 architecture and API contract.
- `signing/100825_27042026_signing-path.md` exists with simulator/dev and real device/TestFlight tracks.
- `decisions/100825_27042026_runtime-unblock-decision.md` exists with lock isolation recommendation.
- No status may be marked `done` unless backed by file/API/live evidence.

## Current Status

- Status: in_progress.
- Evidence created by this update is limited to versioned documentation and runtime/API dashboard patch verification, not a finished Apple Watch app build.
