# Apple Watch Assistant Linux/VPS Readiness - Acceptance Checklist

## Phase A: Linux/VPS Readiness — current phase

This is the current phase.
Linux/VPS Readiness means all feasible VPS-safe artifacts and backend/mock work are completed before any MacBook build/install work starts.
Backend/mock path on Linux/VPS is not blocked.
Do not claim any signed Apple Watch install file in this phase.

### PASS when evidence exists for
- [x] BRD / scope baseline
  - `/root/.openclaw/workspace/projects/apple-watch-assistant/brd/103100_27042026_apple-watch-assistant.md`
- [x] Architecture v0.1
  - `/root/.openclaw/workspace/projects/apple-watch-assistant/architecture/100825_27042026_apple-watch-assistant-architecture.md`
- [x] Signing / install path note with Mac path separated
  - `/root/.openclaw/workspace/projects/apple-watch-assistant/signing/100825_27042026_signing-path.md`
  - `/root/.openclaw/workspace/projects/apple-watch-assistant/install-run/115159_27042026_install-run-test-path.md`
- [x] Runtime isolation khỏi main session lock
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
- [x] Dashboard đọc task source-of-truth
  - `/root/.openclaw/workspace/projects/apple-watch-assistant/tasks/tasks.json`
  - `/root/.openclaw/ops-cockpit/app.py`
- [x] Backend/mock có thể chạy/test trên Linux/VPS nếu `mock_server.py` hỗ trợ
  - `/root/.openclaw/workspace/projects/apple-watch-assistant/app/backend/mock_server.py`
- [x] Không fake done task
  - all `done` rows in `tasks.json` point to real artifact paths
- [x] Không claim có signed Apple Watch install file
  - current readiness artifacts stop at docs/spec/backend mock/skeleton/config examples only

### Output of Phase A
- docs / specs
- backend mock
- API contract
- skeleton structure
- config / security examples
- readiness checklist

### Not output of Phase A
- file cài Apple Watch
- signed build
- TestFlight build
- Xcode archive
- simulator evidence

## Phase B: Mac Build & Install — separated for Minh
- Do not execute in VPS phase.
- Owner: Minh
- Status: Input Required / Not Started

### Input required
- MacBook / Mac build machine
- Xcode
- Apple Developer account / team
- Bundle ID
- signing certificate / provisioning
- paired iPhone / Apple Watch or TestFlight

### Future output
- Xcode project / archive
- simulator run evidence
- real device install evidence
- TestFlight build if needed

## Wording lock
- Linux/VPS Readiness complete does not mean a signed install artifact exists.
- Mac Build & Install is separated for Minh.
- No signed install artifact yet.
