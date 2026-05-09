# Dashboard Progress Tracker BRD Update - Telegram Model Fallback

## Scope Update

Minh requested graceful fallback and recovery monitoring for the Telegram PM/auditor bot when the primary model is unavailable, while preserving a hard distinction between auth/session failures and quota/model availability failures.

Current observed error class:

- `AUTH_EXPIRED`
- HTTP 401 / `token_expired` / ChatGPT session expired
- Fallback to another model is not useful while the same auth/session token is expired.

## Model Routing

Editable routing config:

- `/root/.openclaw/telegram/model-routing.json`

Primary model:

- `9router/cx/gpt-5.4`

Router-advertised fallback models:

- `9router/cx/gpt-5.1-codex-mini`
- `9router/cx/gpt-5-codex-mini`

The requested plain `gpt-4.1` and `gpt-4.1-mini` IDs were not advertised by the configured `9router` `/models` endpoint at implementation time, so the fallback list uses available lower-tier router IDs.

## Error Classification

Implemented classes:

- `AUTH_EXPIRED`: 401, `token_expired`, session expired, invalid token
- `QUOTA_LIMITED`: 429, quota exceeded, rate limit, usage limit
- `MODEL_UNAVAILABLE`: model not found, model overloaded, timeout, upstream/service unavailable
- `UNKNOWN`: safely logged, no infinite retry

Auth/session expiry now stops model fallback instead of walking the same expired credential across fallback candidates.

## Degraded Mode Policy

When fallback is active, status is `DEGRADED_MODE`.

Allowed Telegram tasks:

- PM audit
- Checklist
- Summarization
- Handoff notes
- Status update

Blocked unless Minh explicitly approves:

- Heavy code patch
- Risky infra change
- Secret/token operation
- Cron enable

## Recovery Monitor

Monitor script:

- `/root/.openclaw/telegram/model_router.py`

Status file:

- `/root/.openclaw/telegram/model-routing-state.json`

Cron monitor:

- every 10 minutes
- writes log to `/root/.openclaw/telegram/model-routing.cron.log`

Recovery behavior:

- Ping primary model with a lightweight request.
- If primary succeeds after degraded/auth/offline state, switch back to `PRIMARY_MODE`.
- Send one Telegram recovery notice if configured recipients are available.
- Do not spam repeated unchanged status.

## Dashboard Status

Ops Cockpit metrics now exposes:

```json
{
  "telegramBot": {
    "status": "primary | degraded | auth_expired | offline",
    "primaryModel": "9router/cx/gpt-5.4",
    "activeModel": "...",
    "lastError": "...",
    "lastFallbackAt": "...",
    "lastRecoveredAt": "...",
    "nextPrimaryCheckAt": "..."
  }
}
```

The dashboard model pill is updated to display Telegram bot model state after the Ops Cockpit service reloads.

## Validation Evidence

- Router `/models` inspected without printing API key.
- Config updated without printing secrets.
- `python3 -m py_compile` passed for monitor and Ops Cockpit.
- `node --check` passed for patched OpenClaw runtime files.
- `jq empty` passed for OpenClaw and Telegram model routing JSON files.
- Error classification simulation passed for AUTH_EXPIRED, QUOTA_LIMITED, MODEL_UNAVAILABLE, and UNKNOWN.
- Lightweight primary health check returned `AUTH_EXPIRED`, so current status remains `AUTH_EXPIRED`.
- Ops Cockpit service was restarted after patching so `/api/metrics` now returns the `telegramBot` status field.

## Safety

- No private token/key intentionally printed in final output.
- No gateway restart.
- Ops Cockpit restarted only to load dashboard/API changes.
- No process kill.
- No force push.
- No source deletion.
- Fallback config remains editable.

## Current Status

Status: `AUTH_EXPIRED`

Next Minh action: refresh/re-auth the bot or gateway ChatGPT session. After that, the 10-minute monitor should detect primary recovery and move the bot back to `PRIMARY_MODE`.
