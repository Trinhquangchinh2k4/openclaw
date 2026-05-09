# Apple Watch Assistant BRD Update - 2026-04-27 10:35:00 UTC

## Priority
- Priority: P0
- Telegram is temporary technical executor because IDE/Codex hit usage limit.

## Micro-task Requirement
Create a lightweight project skeleton only. Do not run heavy builds, do not install packages.

## Required Structure
`/root/.openclaw/workspace/projects/apple-watch-assistant/app/`

Contents:
- `README.md`
- `backend/README.md`
- `backend/api_contract.md`
- `backend/mock_server.py`
- `watchos/README.md`
- `watchos/placeholder/`
- `iphone-companion/README.md`
- `shared/config.example.json`

## Rules
- Linux/VPS may proceed immediately with backend/mock/API contract.
- watchOS simulator/real device path still requires Mac/Xcode/signing.
- Do not hardcode secrets.
- Use example config or env only.
- If files are created successfully, the skeleton/repo-structure task may move to `done` with file-path evidence.
