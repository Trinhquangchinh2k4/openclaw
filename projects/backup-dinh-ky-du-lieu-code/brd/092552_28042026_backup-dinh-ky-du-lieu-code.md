# BRD Update - Backup schedule UTC fix

- Version: `092552_28042026_backup-dinh-ky-du-lieu-code.md`
- Project: `backup-dinh-ky-du-lieu-code`
- Time (UTC): 2026-04-28 09:25:52
- Status: `GREEN / DONE`
- Owner: `main`
- Scope: schedule accuracy fix only

## 1. Problem

The previous root crontab relied on `CRON_TZ=Asia/Ho_Chi_Minh`:

```cron
CRON_TZ=Asia/Ho_Chi_Minh
0 3,12 * * * /root/.openclaw/workspace/projects/backup-dinh-ky-du-lieu-code/scripts/backup_push_github.sh --apply --tag --push >> /root/.openclaw/workspace/projects/backup-dinh-ky-du-lieu-code/logs/backup_cron.log 2>&1
```

On this Ubuntu cron implementation, `CRON_TZ` is not honored for scheduling. The previous entry therefore ran at `03:00 UTC` and `12:00 UTC`, which maps to `10:00 ICT` and `19:00 ICT`.

## 2. Correct Schedule

Desired schedule:

- `03:00 ICT`
- `12:00 ICT`

UTC conversion:

- `03:00 ICT` = `20:00 UTC` previous day
- `12:00 ICT` = `05:00 UTC` same day

Updated root crontab:

```cron
0 5,20 * * * /root/.openclaw/workspace/projects/backup-dinh-ky-du-lieu-code/scripts/backup_push_github.sh --apply --tag --push >> /root/.openclaw/workspace/projects/backup-dinh-ky-du-lieu-code/logs/backup_cron.log 2>&1
```

Mapped times:

- `05:00 UTC` -> `12:00 ICT`
- `20:00 UTC` -> `03:00 ICT` next day

## 3. Config State

Registry:

`/root/.openclaw/workspace/projects/backup-dinh-ky-du-lieu-code/config/backup.projects.json`

Current settings:

```json
{
  "backupTimesICT": ["03:00", "12:00"],
  "cronTimesUTC": ["20:00", "05:00"],
  "cronEnabled": true,
  "pushEnabled": false
}
```

## 4. Safety

Deploy key was not changed.

Backup script was not changed.

No backup push was run.

No secrets or private keys were printed.

Only the root crontab schedule and local status/config evidence were updated.

## 5. Final Status

GitHub push verification remains `PASS`.

Restore dry-run from pushed tag remains `PASS`.

Cron remains enabled.

Schedule accuracy is now `PASS` using UTC-converted cron times.
