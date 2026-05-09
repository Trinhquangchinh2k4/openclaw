# BRD Update - Apple Watch Assistant

- Version: `083700_27042026_apple-watch-assistant.md`
- Project: `apple-watch-assistant`
- Time (UTC): 2026-04-27 08:37:00
- Owner: `main` (PM)
- BA support: `huyen`
- Model lock: `9router/cx/gpt-5.4`

## Requirement Update
Apple Watch project is now included in the same task source-of-truth rule used by the dashboard.

## Progress Rule
- Only formula: `done_task / total_task * 100`
- Tasks must include `project_id`, `owner`, `status`

## Current Position
- Project remains backlog but progress display must still come from real task rows, not hardcoded percentages.
