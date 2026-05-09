# Runtime Unblock Decision - Apple Watch Assistant - 2026-04-27 10:08:25 UTC

## Runtime Nghen O Dau

The known risk is the OpenClaw `main` session lock under `/root/.openclaw/agents/main/sessions/`. Apple Watch backend assistant requests must not depend on that write lock. If they do, P0 can be blocked by unrelated main/Telegram/runtime activity.

Initial inspection in this pass found no `*.lock` file under `/root/.openclaw/agents/main/sessions/`. After Ops Cockpit restart and `/api/metrics` verification, `openclaw-gateway` PID `34606` created a fresh main session lock again. The verified API state is `mode: isolated`, `blocking: false`, and `appleWatchBlocking: false`; therefore this is an active fresh main lock, not the stale blocking state reported earlier.

## Option A: Clear / Restart Lock

- Use only after inspecting PID, process liveness, lock freshness, and open file handles.
- Good for stale locks.
- Risk: clearing an active lock can corrupt or interrupt the main session.

## Option B: Isolated Apple Watch Session

- Create/use a dedicated Apple Watch session id/path such as `apple-watch-assistant`.
- Write logs under the Apple Watch project runtime folder or a dedicated agent session folder.
- Do not acquire the main session write lock for watch requests.
- Recommended default.

## Option C: Read-Only Snapshot

- Read main context as a snapshot when needed.
- Do not write into main session during Apple Watch request handling.
- Good as a compatibility bridge.

## Option D: Async Queue Rieng

- Queue Apple Watch requests into a dedicated assistant worker.
- Worker owns Apple Watch session/log writes.
- Useful if voice/STT/TTS calls need retries or longer execution windows.

## Recommendation

Default action: isolate Apple Watch backend assistant session so P0 does not wait on the main session lock.

## Default Action Planned In This Pass

- Add/verify dashboard/API status that main session lock is not considered an Apple Watch backend blocker when isolated.
- Create a dedicated Apple Watch runtime log/session folder for the project if needed by the backend mock.
- Keep main lock intact unless inspection proves it is stale and safe to recover.

## Default Action Done In This Pass

- Created isolated runtime folders:
  - `/root/.openclaw/workspace/projects/apple-watch-assistant/runtime/logs`
  - `/root/.openclaw/workspace/projects/apple-watch-assistant/runtime/sessions`
- Patched Ops Cockpit metrics to expose `appleWatchRuntime` with:
  - `sessionId: apple-watch-assistant`
  - `isolated: true`
  - `mainSessionLockBlocking: false`
  - dedicated session/log paths.
- Did not delete or clear any lock blindly.

## Lock Evidence

```text
$ find /root/.openclaw/agents/main/sessions -maxdepth 1 -name '*.lock' -print -ls
(no output)

$ ps -fp 34606 || true
UID          PID    PPID  C STIME TTY          TIME CMD
root       34606     703  4 Apr26 ?        00:59:47 openclaw-gateway

$ lsof -p 34606 | head -80 || true
openclaw- 34606 root   21w REG 253,1 117 398189 /tmp/openclaw-0/gateway.a504a3cd.lock
openclaw- 34606 root   22u IPv4 ... TCP localhost:18789 (LISTEN)
openclaw- 34606 root   30u IPv4 ... TCP localhost:18791 (LISTEN)
```

After restart/API verification:

```text
$ stat /root/.openclaw/agents/main/sessions/*.lock
File: /root/.openclaw/agents/main/sessions/8037c449-a64f-4180-9d39-a748c1d8f664.jsonl.lock
Size: 85
Modify: 2026-04-27 10:13:33.722000000 +0000

$ /api/metrics gateway.sessionLock
mode: isolated
blocking: false
appleWatchBlocking: false
ownerPid: 34606
statusText: Main session lock is active, heartbeat fresh; Apple Watch backend path is isolated and non-blocking
```

Latest local/public `/api/metrics` sample at `2026-04-27T10:14:35Z` reported:

```text
gateway.sessionLock.mode: missing
gateway.sessionLock.blocking: false
gateway.sessionLock.appleWatchBlocking: false
appleWatchRuntime.isolated: true
appleWatchRuntime.blockedEndpoint: null
```

## Risk

- If backend implementation later reuses a generic `main` session write path, the lock can regress into a real blocker.
- Dashboard must state endpoint-specific blockage if any Apple Watch endpoint is actually blocked.

## Minh Approval Needed

- Approve Track B signing inputs for real device/TestFlight.
- Approve whether Apple Watch runtime should use only backend-hosted model calls or allow direct iPhone relay credentials with scoped tokens later.
- No approval needed to keep backend/mock/spec work moving on isolated session path.
