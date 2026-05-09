# BRD Update - Backup dinh ky du lieu code

- Version: `011916_28042026_backup-dinh-ky-du-lieu-code.md`
- Project: `backup-dinh-ky-du-lieu-code`
- Time (UTC): 2026-04-28 01:19:16
- Status: `AMBER / INPUT_REQUIRED`
- Owner: `main`
- Clarifier: `Minh`

## 1. DR Design Status

The disaster recovery design from `004811_28042026_backup-dinh-ky-du-lieu-code.md` is accepted.

No redesign is required in this update. The accepted architecture remains:

- central GitHub backup repo: `openclaw-code-backup`
- per-project backup registry
- project-separated backup tree under `backups/projects/<project-id>`
- support for 100+ future projects by registry entry
- source/code/docs/tasks included
- secrets, dependencies, build artifacts, caches, local databases, archives, and large runtime media excluded

## 2. Schedule Update

Old schedule:

- `03:00 ICT`

New schedule:

- `03:00 ICT`
- `12:00 ICT`

Canonical config:

```json
"backupTimesICT": ["03:00", "12:00"],
"cronEnabled": false,
"pushEnabled": false
```

Cron remains disabled. The cron proposal, not installed:

```cron
CRON_TZ=Asia/Ho_Chi_Minh
0 3,12 * * * /root/.openclaw/workspace/projects/backup-dinh-ky-du-lieu-code/scripts/backup_push_github.sh --apply --tag --push
```

## 3. GitHub Target

Repo URLs are already provided:

- HTTPS: `https://github.com/Trinhquangchinh2k4/openclaw-code-backup.git`
- SSH: `git@github.com:Trinhquangchinh2k4/openclaw-code-backup.git`

Deploy key public key is the next input step for Minh.

Repo-specific deploy key path:

`/root/.openclaw/workspace/projects/backup-dinh-ky-du-lieu-code/github-push/openclaw_backup_github_ed25519`

Only the `.pub` public key may be printed. The private key must not be printed and must stay `chmod 600`.

## 4. Safety Gate

Do not run `git ls-remote` until Minh confirms the public key has been added to GitHub Deploy Keys with `Allow write access`.

Do not push.

Do not enable cron.

Manual push test is still required before cron:

1. Minh adds the public deploy key to GitHub with write access.
2. Run `git ls-remote` against the SSH URL.
3. Run manual backup push test.
4. Confirm commit/tag evidence exists.
5. Only after that, discuss enabling cron for `03:00 ICT` and `12:00 ICT`.

## 5. Current Status

Expected status remains `AMBER / INPUT_REQUIRED`.

The project must not be marked done or GREEN until manual push commit/tag evidence exists and Minh explicitly approves cron enablement.
