# Dashboard Progress Tracker BRD Update - Backlog Grouping And Workload Semantics

## Priority

- Priority: P1.
- Scope: project progress tree view, backlog grouping, mobile compactness, and workload semantics.
- Memory rule: lightweight backend/frontend patch only; no heavy build or broad filesystem scan.

## Requirements

- Group tree nodes by status at every level:
  - Blocked first and visually prominent.
  - Active / In Progress next.
  - Not Started next.
  - Backlog lower.
  - Done / Archived lower and collapsible by default.
- Add compact status badges for:
  - Not Started
  - Active
  - In Progress
  - Backlog
  - Blocked
  - Done
  - Archived
- Mobile view must keep sprint/milestone and user story detail compact:
  - summary visible first;
  - acceptance criteria, output, and blocker note inside expandable detail;
  - task row shows task name, assignee, progress, and status badge.
- Refactor workload semantics:
  - `owner`
  - `assignee`
  - `reviewer`
  - `supporters`
  - `weights.ownership`
  - `weights.execution`
  - `weights.review`
  - `weights.support`
- Only task assignee counts as primary execution workload.
- Project/epic/sprint owner counts as light ownership workload only.
- Reviewer and supporters count in separate review/support workload.
- Do not propagate project owner to all child tasks as assignee.

## Acceptance

- Active items render before backlog.
- Backlog has its own visual group.
- Status badge appears on every tree node.
- Mobile task rows stay compact.
- PM/main can be shown as managing/ownership without being shown as doing every task.
- Execution workload is based mainly on task assignee.
- Unassigned tasks display `Unassigned`.
