# Beads Manual Fallback

`bd` CLI was not found in PATH during policy installation.

Do not install packages with `apt` or `curl` without explicit approval.

Until Beads CLI is available, use:

```text
state/tasks.jsonl
```

Each fallback task row should include:

- id
- title
- status
- risk
- openspec
- owner
- acceptance_criteria
- evidence_required
- created_at
- updated_at

When `bd` becomes available, migrate fallback rows into Beads.

