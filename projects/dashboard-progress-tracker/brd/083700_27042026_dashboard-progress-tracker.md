# BRD Update - Dashboard Project Progress Tracker

- Version: `083700_27042026_dashboard-progress-tracker.md`
- Project: `dashboard-progress-tracker`
- Time (UTC): 2026-04-27 08:37:00
- Owner: `main` (PM)
- BA support: `huyen`
- Model lock: `9router/cx/gpt-5.4`

## Requirement Update
User rejected progress-by-declaration and required live dashboard logic to be driven from task source-of-truth.

## Mandatory Rules
1. Progress is not allowed to be cảm tính.
2. Progress must come from task source-of-truth.
3. Single formula: `done_task / total_task * 100`.
4. Each task must have at least:
   - `project_id`
   - `owner`
   - `status`
5. Every new requirement must create/update a BRD versioned markdown in the correct project folder.
6. Dashboard must read runtime task data, not hardcode project percentages.

## Scope of this BRD Update
- Create real task source-of-truth per project under project folder.
- Patch dashboard backend progress calculation to read tasks.
- Patch dashboard frontend labels to show done/total task semantics.
- Verify live after restart.

## Acceptance Criteria
- Every tracked project has `brd/` and `tasks/`.
- Every project has real task breakdown persisted in source-of-truth file.
- `/api/metrics` returns project progress derived from done/total tasks.
- Dashboard active project and portfolio render task-based percentages.

## RAG
- Status: AMBER
- Reason: logic can be implemented immediately, but some unrelated runtime blockers remain outside progress rendering scope.
