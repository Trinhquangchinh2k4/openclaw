# Apple Watch Assistant MVP Readiness - Acceptance Checklist

## Phase A: Apple Watch Assistant MVP Readiness — current phase

This is the current phase.
Phase A does **not** claim that a signed Apple Watch install file already exists.
Phase A only means the project has enough readiness artifacts to move into the future Build & Install phase.
Backend/mock path on Linux/VPS is not blocked.
Mac/Xcode/signing remains **Input Required** for real device / TestFlight.

### Checklist evidence
- [x] BRD / scope baseline
  - `/root/.openclaw/workspace/projects/apple-watch-assistant/brd/103100_27042026_apple-watch-assistant.md`
- [x] Architecture v0.1
  - `/root/.openclaw/workspace/projects/apple-watch-assistant/architecture/100825_27042026_apple-watch-assistant-architecture.md`
- [x] Signing / install path note
  - `/root/.openclaw/workspace/projects/apple-watch-assistant/signing/100825_27042026_signing-path.md`
  - `/root/.openclaw/workspace/projects/apple-watch-assistant/install-run/115159_27042026_install-run-test-path.md`
- [x] Runtime isolation
  - `/root/.openclaw/workspace/projects/apple-watch-assistant/runtime/100825_27042026_runtime-isolation.md`
- [x] App skeleton
  - `/root/.openclaw/workspace/projects/apple-watch-assistant/app/README.md`
  - `/root/.openclaw/workspace/projects/apple-watch-assistant/app/watchos/README.md`
  - `/root/.openclaw/workspace/projects/apple-watch-assistant/app/iphone-companion/README.md`
- [x] Backend mock / API contract
  - `/root/.openclaw/workspace/projects/apple-watch-assistant/app/backend/mock_server.py`
  - `/root/.openclaw/workspace/projects/apple-watch-assistant/app/backend/api_contract.md`
- [x] Vietnamese voice assistant spec
  - `/root/.openclaw/workspace/projects/apple-watch-assistant/voice/115159_27042026_vietnamese-voice-assistant-spec.md`
- [x] Security / config spec
  - `/root/.openclaw/workspace/projects/apple-watch-assistant/security/115641_27042026_security-config.md`
  - `/root/.openclaw/workspace/projects/apple-watch-assistant/app/shared/config.example.json`
  - `/root/.openclaw/workspace/projects/apple-watch-assistant/app/.env.example`
- [x] Dashboard progress reads task source-of-truth
  - `/root/.openclaw/workspace/projects/apple-watch-assistant/tasks/tasks.json`
  - `/root/.openclaw/ops-cockpit/app.py`
- [x] No fake done tasks
  - `tasks.json` done rows point to real artifact evidence paths
- [x] Mac/Xcode/signing correctly marked as Input Required
  - blocker remains: `Input Required: Mac/Xcode/signing for real device/TestFlight`

### Phase A output
Phase A output is limited to:
- readiness artifacts
- backend/mock/skeleton
- API contract
- config/security/voice specs

Phase A output is **not**:
- a signed Apple Watch install file
- a real-device install proof
- a TestFlight build

## Phase B: Apple Watch Build & Install — next phase, not current

Phase B must only open after Phase A reaches 8/8 readiness.

### Input required
- Mac build machine
- Xcode
- Apple Developer account / team
- Bundle ID
- certificate / provisioning
- paired iPhone + Apple Watch, or TestFlight path

### Future output
- Xcode project / archive
- simulator run evidence
- real device install evidence or TestFlight build
- signed build artifact if available

## Important wording
- Do not claim “có file cài Apple Watch” in Phase A.
- 8/8 readiness is not a signed install build.
- Build & Install phase is next and requires Mac/Xcode/signing.
