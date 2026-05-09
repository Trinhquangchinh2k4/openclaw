# BRD Update - Backup dinh ky du lieu code

- Version: `004811_28042026_backup-dinh-ky-du-lieu-code.md`
- Project: `backup-dinh-ky-du-lieu-code`
- Time (UTC): 2026-04-28 00:48:11
- Status: `AMBER / INPUT_REQUIRED`
- Owner: `main`
- Clarifier: `Minh`

## 1. Updated Scope

The scope is now full disaster recovery for OpenClaw project work, not only BRD/tasks backup.

If the OpenClaw server dies, Minh must be able to restore project source code, project files, docs, BRDs, tasks, scripts, and supporting project artifacts from GitHub backup.

The backup architecture must support 100+ future projects by registry entry. Adding a new project should not require rewriting the backup script.

## 2. Central Repository

Central backup repository is allowed:

- HTTPS: `https://github.com/Trinhquangchinh2k4/openclaw-code-backup.git`
- SSH: `git@github.com:Trinhquangchinh2k4/openclaw-code-backup.git`
- Branch: `main`

The repository must not be a flat dump. It must be structured per project:

```text
backups/
  projects/
    apple-watch-assistant/
    dashboard-progress-tracker/
    backup-dinh-ky-du-lieu-code/
  backup-system/
  backup.projects.json
  backup.exclude
  restore_project.sh
  restore_all.sh
  reports/
```

## 3. Registry

The source of truth for backup scope is:

`/root/.openclaw/workspace/projects/backup-dinh-ky-du-lieu-code/config/backup.projects.json`

Each project entry has:

- `id`
- `enabled`
- `sourcePaths`
- `restorePath`
- `backupSubdir`
- `excludes`

Initial enabled projects:

- `apple-watch-assistant`
- `dashboard-progress-tracker`
- `backup-dinh-ky-du-lieu-code`

`dashboard-progress-tracker` includes both the project directory and `/root/.openclaw/ops-cockpit`.

## 4. Exclusion Policy

Source code and project files are included.

Secrets, deploy keys, tokens, dependency folders, build outputs, caches, databases, logs, archives, and large binary media are excluded by:

`/root/.openclaw/workspace/projects/backup-dinh-ky-du-lieu-code/config/backup.exclude`

Large files are excluded from Git backup. If future projects need large assets, they require a separate storage policy outside this Git backup.

## 5. Push And Cron Policy

Defaults remain locked:

- `pushEnabled=false`
- `cronEnabled=false`
- cron design remains `03:00 ICT`

Deploy key with write access is still required before any real push.

Manual push test is required before cron discussion:

1. `bash -n` all scripts.
2. Run local dry-run.
3. Print public deploy key only if it has not already been printed.
4. Minh adds deploy key to GitHub with write access.
5. Run `git ls-remote` against the SSH URL.
6. Run manual push test.
7. Confirm commit/tag evidence.
8. Only then discuss enabling cron at `03:00 ICT`.

Private keys, tokens, `.env`, and secrets must never be printed in chat, logs, BRDs, manifests, or scripts.

## 6. Restore Policy

Restore scripts:

- `/root/.openclaw/workspace/projects/backup-dinh-ky-du-lieu-code/scripts/restore_project.sh`
- `/root/.openclaw/workspace/projects/backup-dinh-ky-du-lieu-code/scripts/restore_all.sh`

`restore_project.sh <project-id>` is dry-run by default. It prints the manifest and restore plan. It does not write or overwrite files unless `--apply` is supplied.

For projects with multiple source paths, the first source restores to `restorePath`; secondary source roots restore to their original absolute source paths as recorded in the registry.

## 7. Acceptance State

This update is not final completion.

Current state is `AMBER / INPUT_REQUIRED` until:

- Minh adds the GitHub deploy key with write access.
- `git ls-remote` passes.
- A manual backup push creates verifiable commit/tag evidence in `openclaw-code-backup`.
- Minh approves cron enablement after the manual push succeeds.
