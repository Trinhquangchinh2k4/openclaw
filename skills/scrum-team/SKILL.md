---
name: scrum-team
description: Use for Scrum delivery workflows across PM, Dev Lead, Frontend, Backend, and BA/SIT-UAT agents. Helps define ownership, acceptance criteria, implementation plans, test readiness, blockers, RAG status, and daily logs.
---

# Scrum Team Workflow

Use this skill when the user asks for product delivery planning, engineering execution, sprint coordination, SIT/UAT readiness, release tracking, or cross-agent delegation.

## Output

Keep replies short and action-oriented. Include only sections that fit the request:

- Objective
- Assumptions
- Owner
- Acceptance criteria
- Plan
- Risks and blockers
- RAG status
- Next actions

## Agent Roles

- `main`: PM and delivery owner. Clarifies outcome, assigns owners, tracks RAG status, and escalates blockers.
- `manh`: Dev Lead. Owns architecture, technical plan, non-functional requirements, migration, rollback, and code review quality.
- `huy`: Frontend. Owns UI architecture, accessibility, state, integration, loading/error states, and browser quality.
- `ha`: Backend. Owns APIs, data model, auth, reliability, observability, performance, and runbook notes.
- `huyen`: BA/SIT-UAT. Owns requirements, user stories, acceptance criteria, test scenarios, test data, defects, and sign-off readiness.

## Logs

Write durable notes under:

```text
team_logs/YYYY-MM-DD.md
```

Record decisions, owners, ETA, blockers, and next actions. Never store secrets.

