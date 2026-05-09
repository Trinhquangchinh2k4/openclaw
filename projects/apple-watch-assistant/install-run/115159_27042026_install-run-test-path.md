# Apple Watch Assistant MVP Readiness - Install / Run / Test Path

## Scope wording
Current phase is **Apple Watch Assistant MVP Readiness**.
This phase must **not** be described as already having an installable Apple Watch signed build.

## 1) Linux/VPS path — unblocked now
What is unblocked now:
- backend mock/API contract on VPS
- Python stdlib mock server path
- request/response testing with `curl` or Python stdlib
- source-of-truth task and readiness artifact updates

What this path does not produce:
- no signed Apple Watch install file
- no watchOS simulator build
- no real Apple Watch install artifact
- no TestFlight package

Verification style on VPS:
- test `POST /assistant/message`
- test `POST /assistant/voice` as placeholder/mock contract
- test `GET /assistant/session/:id`
- test `GET /health`
- test `GET /metrics`
- use `curl` or Python stdlib only

Mac/Xcode required:
- no

## 2) Mac simulator path — input required
Requirements:
- Mac
- Xcode
- watchOS simulator
- Apple platform runtime/toolchain

Execution path:
- create watchOS/iPhone project in Xcode
- build/run through Xcode or `xcodebuild`
- validate simulator UI, permissions, networking, and pairing flow

Current status on VPS:
- not executed
- no simulator artifact produced here

## 3) Real Apple Watch / TestFlight path — input required
Requirements:
- Apple Developer account/team
- Bundle ID
- certificate and provisioning
- paired iPhone + Apple Watch, or TestFlight distribution path
- signing assets and release workflow

Current status:
- no signed install artifact
- no real-device install proof
- no TestFlight proof
- not executable from VPS alone

## Current readiness statement
- backend/mock path is unblocked now
- simulator path is input required
- real device/TestFlight path is input required
- there is still no signed Apple Watch install file in the current phase

## Evidence links
- BRD baseline: `/root/.openclaw/workspace/projects/apple-watch-assistant/brd/103100_27042026_apple-watch-assistant.md`
- signing path: `/root/.openclaw/workspace/projects/apple-watch-assistant/signing/100825_27042026_signing-path.md`
- backend skeleton: `/root/.openclaw/workspace/projects/apple-watch-assistant/app/`
