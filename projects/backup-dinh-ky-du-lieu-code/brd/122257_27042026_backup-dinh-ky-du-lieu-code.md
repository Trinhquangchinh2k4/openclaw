# Backup định kỳ dữ liệu code

## Mục tiêu
Thiết kế quy trình backup code định kỳ trên Linux/VPS cho các workspace/project quan trọng, ưu tiên dry-run local an toàn trước. Push GitHub thật chỉ thực hiện sau khi Minh cung cấp repo đích và token/quyền push phù hợp.

## Source folders dự kiến backup
- `/root/.openclaw/workspace/projects/apple-watch-assistant`
- `/root/.openclaw/workspace/projects/dashboard-progress-tracker`
- `/root/.openclaw/workspace/projects/backup-dinh-ky-du-lieu-code`
- `/root/.openclaw/workspace/team_logs`
- có thể mở rộng thêm manifest sau, nhưng không quét/bundle toàn bộ `/root`

## GitHub repo đích
- Input Required nếu Minh chưa cung cấp repo private và quyền push/token an toàn
- không push thật trong phase hiện tại nếu chưa có repo/token

## Lịch backup
- lịch mục tiêu: `03:00 ICT`
- chưa bật cron thật nếu Minh chưa approve
- ưu tiên dry-run local trước

## Version / tag format
- format timestamp: `HHMMSS_DDMMYYYY_<repo-name>`
- backup output local nên dùng cùng format để dễ đối chiếu với repo/tag tương lai

## Dry-run local trước
- tạo script backup local chỉ để gom danh sách file, copy artifact an toàn, và sinh evidence/log
- chưa push GitHub thật trong giai đoạn này

## Security rule
- không backup secret/token/.env thật
- loại trừ secret files, credential files, `.env`, `.pem`, `.key`, token cache, và các secret path tương đương
- không expose token/repo credential trong script, log, task evidence, hoặc dashboard
