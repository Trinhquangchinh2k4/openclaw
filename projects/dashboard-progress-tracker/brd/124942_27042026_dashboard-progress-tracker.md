# Dashboard Progress Tracker Cleanup

## Context
- Apple Watch Phase A đã PASS
- Backup Linux/VPS dry-run đã PASS
- dashboard cần cleanup để phản ánh phase/status đúng theo source-of-truth hiện tại
- future/manual phase không được bị hiểu là blocker execution hiện tại

## Audit targets via /api/metrics
### Apple Watch
- phải hiện `8/8`
- phải hiện `100.0%`
- Phase A PASS
- Phase B deferred/manual by Minh, không phải blocker hiện tại

### Backup
- phải hiện `6/8`
- phải hiện `75.0%`
- Dry-run readiness PASS
- GitHub push deferred/input required, không phải lỗi execution

### Agent token panel
- đủ 5 agent
- token fields hiện cho cả agent token = 0

### Memory card
- RAM used/total
- RAM available
- swap used/total
- top processes
- risk status

### Alerts
- không còn stale alert cho:
  - Apple Watch missing architecture
  - Apple Watch 0/8
  - Backup missing task runtime
  - GitHub repo/token bị hiểu là lỗi execution hiện tại
- chỉ giữ future/manual/input-required note đúng nghĩa

### Mobile bottom blank
- nếu chưa verify được bằng browser/runtime thì giữ AMBER
- wording: `Awaiting user mobile verification`
- không claim pass nếu chưa có proof
