# Dashboard Progress Tracker BRD Update - 2026-04-27 10:23:00 UTC

## Priority

- Priority: P1
- This supports P0 Apple Watch delivery and live operational truth.
- PM role here is audit/co-ordination only; technical executor is Codex IDE in VS Code.

## New Requirement: Memory Guard Phase 2

User does **not** accept any claim of `memory optimized` just because swap 2GB was created.

### Non-acceptance conditions

Do not claim optimization if any of the below remain true:
- physical RAM still around `3.6 / 3.8 GB` or ~`94%`
- no diagnosis yet for `openclaw-gateway` around `1.9 GB`
- no diagnosis yet for VS Code `extensionHost` around `1.09 GB`
- dashboard memory card still lacks `RAM available`, `swap`, and `top processes`

## Required IDE Execution

1. Identify top RAM processes.
2. Diagnose whether `openclaw-gateway` is holding excessive memory because of leak/cache/log/session load.
3. If safe, patch memory pressure controls such as history/log/session caps or do a graceful gateway restart.
4. Update dashboard memory card to show:
   - RAM used
   - RAM available
   - swap used / total
   - top memory-consuming processes
5. Avoid reckless actions:
   - do not kill processes blindly
   - do not run heavy builds while memory is already constrained

## Evidence Requirements

Acceptance evidence must include:
- command output showing top RAM processes
- diagnosis notes for `openclaw-gateway`
- diagnosis notes for VS Code `extensionHost`
- exact file(s) patched for dashboard memory card if UI is changed
- live `/api/metrics` or UI evidence showing available RAM + swap + top processes

## Status Rule

- PM must not report `GREEN`, `done`, or `xong` until live evidence shows the required fields and diagnosis.
- If swap exists but physical RAM remains saturated, status stays `AMBER` or `RED` depending on impact.
