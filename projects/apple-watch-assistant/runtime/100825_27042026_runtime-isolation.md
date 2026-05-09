# Apple Watch Runtime Isolation Evidence - 2026-04-27

- Isolated session id: `apple-watch-assistant`.
- Session path: `/root/.openclaw/workspace/projects/apple-watch-assistant/runtime/sessions/apple-watch-assistant`.
- Log path: `/root/.openclaw/workspace/projects/apple-watch-assistant/runtime/logs/apple-watch-assistant.jsonl`.
- Rule: Apple Watch assistant requests must not acquire the OpenClaw `main` session write lock.
- Current evidence: no `*.lock` file exists under `/root/.openclaw/agents/main/sessions/` during this execution pass.
- Current gateway process: PID `34606` `openclaw-gateway` remains alive and owns `/tmp/openclaw-0/gateway.a504a3cd.lock`.

Status: in_progress until backend mock endpoints are implemented and verified against this isolated path.
