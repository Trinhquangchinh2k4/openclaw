# Dashboard Progress Tracker BRD Update - 2026-04-27 10:08:25 UTC

## Priority

- Priority: P1.
- Dashboard supports P0 Apple Watch delivery visibility and must not report fake completion.

## New Requirements

- Agent token panel must show all 5 agents:
  - VinTNM PM / `main`
  - VinTNM BA / `huyen`
  - VinTNM Backend / `ha`
  - VinTNM Frontend / `huy`
  - VinTNM Dev Lead / `manh`
- Agents without real token usage must still show token fields with `0`.
- Header `0/5 online` must not imply token data is missing; agent cards must show token fields regardless of online state.
- Alert `Dev agents chưa có token thật` must become a specific token instrumentation status listing active and inactive/no-token agents.
- Alert stale cleanup is required for architecture, signing, gateway/session lock, PD runtime decision, token instrumentation, and task runtime truth.
- Mobile bottom blank space must be fixed until the long black tail is gone or measured with debug evidence.

## Required Agent Card Fields

Every agent card must show:

- Token active: yes/no
- Input: N
- Output: N
- Total: N
- Assigned: N
- Executing: N
- Last updated: timestamp or null/none

## Acceptance For This Update

- `/api/metrics` returns 5 agent objects, each with `id`, `name`, `role`, `person`, `online`, `sessionCount`, `assignedCount`, `executingCount`, `tokenActive`, `inputTokens`, `outputTokens`, `totalTokens`, `lastUpdated`, and `dataSource`.
- Frontend renders the same token fields even when values are zero.
- Alert wording is specific and does not keep stale generic blockers after evidence files exist.
- Mobile excess blank target is `excessPx <= 32px` when browser debug can run; if not, CSS root cause and verification limitation must be recorded.

## Current Status

- Status: in_progress.
- No dashboard status should be reported as `GREEN` or complete until live API/UI evidence is collected.
