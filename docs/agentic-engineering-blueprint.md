# Agentic Engineering Blueprint

Source status: `Agentic_Engineering_Blueprint_full_content.md` was not found in the current workspace during installation, so this file captures the enforced blueprint summary from the P3B request.

## Operating Model

Every project follows:

```text
OpenSpec -> Beads -> Superpowers -> Evidence -> Review/Merge
```

The model is not allowed to treat a prompt as the only source of truth. Durable files in this repository define policy, task state, evidence expectations, and review gates so fallback models and new runtime sessions can recover the same rules.

## Non-Negotiables

- Không merge bằng niềm tin.
- Chỉ merge bằng bằng chứng.
- Every AI-generated code change must trace to:
  1. spec
  2. task/bead
  3. workflow/skill
  4. evidence
- Do not report done without evidence.
- No validation means no production.

## Traceability Chain

1. `OpenSpec`: define intended behavior, constraints, and acceptance criteria.
2. `Beads`: track the executable task unit and owner.
3. `Superpowers`: choose the workflow: brainstorm, design sign-off, plan, TDD, debugging, review, or evidence report.
4. `Evidence`: capture commands, tests, logs, screenshots, API checks, diff summary, and rollback.
5. `Review/Merge`: human decision checks the diff and evidence before accepting risk.

## Risk Model

- `GREEN`: docs, read-only checks, low-risk local validation.
- `YELLOW`: scoped code/config changes, local reloads, migrations with rollback, CI/test impact.
- `RED`: production-impacting changes, destructive operations, secrets/auth/network/firewall/DNS/public binding/data migrations.

## Runtime Rule

Each model call should receive only a short summary:

> Use Agentic Engineering: classify risk, trace to spec/task, produce evidence, do not claim done without validation.

The full blueprint stays in docs and is not injected into every request.

