# Agentic Engineering Policy

This workspace uses:

```text
OpenSpec -> Beads -> Superpowers -> Evidence -> Review/Merge
```

Required message:

- Không merge bằng niềm tin.
- Chỉ merge bằng bằng chứng.
- Mọi code AI sinh ra phải trace được về spec, task/bead, workflow/skill, and evidence.
- Không báo done nếu thiếu evidence.
- do not mark done without evidence.
- Không có kiểm chứng thì không có production.

## Practical Rules

Before writing code:

1. Classify risk: `GREEN`, `YELLOW`, or `RED`.
2. Read or identify the relevant OpenSpec.
3. Identify the task/bead.
4. Write acceptance criteria.
5. Define the evidence plan.

During implementation:

1. Stay inside task scope.
2. Avoid unrelated edits.
3. Backup before config/production changes.
4. Never log secrets.
5. Never execute raw sudo/shell from Telegram.

Before completion:

1. Run validation/tests.
2. Summarize the diff.
3. Produce evidence.
4. Update task/bead or fallback task log.
5. Do not mark done without evidence.

Production rules:

1. Backup config first.
2. Syntax check before reload/restart.
3. Rollback path required.
4. No force push.
5. No public bind/firewall/DNS/secret change without explicit approval.
