# Dashboard Progress Tracker BRD Update - Stable Project Progress Detail Panel

## Priority

- Priority: P1.
- Scope: desktop dashboard project progress UI.
- Memory rule: lightweight JS/CSS patch only, no build, no heavy filesystem scan.

## Problem

When a user opens project progress details by clicking a project progress value/card, the detail view collapses too quickly when the user hovers, clicks, scrolls, or expands content inside the panel. This makes the project progress detail unreadable.

## Requirements

- Project detail panel must stay open while the user hovers, clicks, scrolls, or expands/collapses nodes inside it.
- Panel may close only when:
  - the user clicks close X;
  - the user clicks outside both the trigger and panel;
  - the user clicks the currently open project trigger again;
  - the user selects another project, which replaces the old panel.
- Convert detail content into a controlled tree view:
  - Project
  - Epic / MVP Module
  - Sprint
  - User Story
  - Task
- Task level must show assignee, progress, status, deadline if present, and blocker note if present.
- If backend data lacks epic/sprint levels, frontend adapter must synthesize:
  - Epic: `MVP Scope`
  - Sprint: current milestone or `Sprint 1`

## Technical Direction

- Add controlled state:
  - `selectedProjectId`
  - `isDetailPanelOpen`
  - `expandedNodeIds`
  - `activeNodeId`
- Use trigger/panel containment checks for click outside.
- Do not use hover/focus to control open/close.
- Stop treating native popover/tooltip/hover behavior as the source of truth.
- Support future backend tree nodes with shape `{ id, type, name, goal, output, progress, status, assignee, deadline, blockerNote, children }`.

## Acceptance

- Clicking a project progress trigger opens the panel.
- Clicking/scrolling inside the panel does not close it.
- Expanding/collapsing tree nodes does not close it.
- Clicking close X closes it.
- Clicking outside closes it.
- Clicking another project trigger swaps the panel to the new project.
- Tree view shows task assignee/progress/status and `Unassigned` where missing.
