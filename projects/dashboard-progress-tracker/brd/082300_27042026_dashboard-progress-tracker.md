# BRD Update - Dashboard Project Progress Tracker

- Version: `082300_27042026_dashboard-progress-tracker.md`
- Project: `dashboard-progress-tracker`
- Time (UTC): 2026-04-27 08:23:00
- Owner: `main` (PM)
- BA support: `huyen`
- Model lock: `9router/cx/gpt-5.4`

## New User Request
User clarified that project progress should use a simple task-based rule:
- If work item A has `10` tasks and `6` are completed, progress = `60%`.
- PM/BA may decide how to break work into user stories / tasks.
- User only cares about:
  - actual progress
  - final output/product

User also requested a continuous BRD operating rule:
- Every new user requirement must create or update a BRD file.
- File naming format: `HHMMSS_DDMMYYYY_<project-name>.md`
- BRD must be stored under the correct project folder.
- This BRD update task is priority work for PM/BA and must not block FE/BE/Dev Lead execution.

## Outcome Required
1. Replace ambiguous progress reporting with task-count based progress.
2. Maintain a versioned BRD trail for every important requirement/update.
3. Keep current dashboard UI style while making project status decision-grade.

## Scope Update
### In scope
- Task-based project progress model for dashboard project tracking.
- BRD folder + versioned BRD updates for this project.
- PM/BA process to keep BRD current on every new requirement.

### Out of scope for this BRD update
- Full redesign of dashboard UI.
- Non-dashboard Apple Watch implementation details.
- Backup execution implementation itself.

## Functional Rule
- Progress formula baseline: `done_tasks / total_tasks * 100`.
- Each task must have:
  - id
  - title
  - owner/assignee
  - status (`todo`, `in_progress`, `done`, `blocked`)
  - output/deliverable note
- User story progress can be derived from child tasks.
- Milestone progress can be derived from child stories.
- Project progress can be derived from child milestones or full task rollup.

## Assumptions
- PM/BA define the task decomposition.
- Only completed tasks count toward done progress.
- Blocked/in-progress tasks do not count as done.
- Dashboard should show output and owner clearly.

## Acceptance Criteria
- Dashboard progress can be explained by exact task counts.
- User can read progress and understand final output path.
- BRD file exists for this request under the correct project folder.

## RAG
- Status: AMBER
- Reason: BRD rule is clear, but dashboard engine still needs implementation alignment.

## Next Actions
1. PM/BA keep creating BRD update files for new requirements.
2. Backend maps project progress to task counts.
3. Frontend shows progress in task-based terms when needed.
