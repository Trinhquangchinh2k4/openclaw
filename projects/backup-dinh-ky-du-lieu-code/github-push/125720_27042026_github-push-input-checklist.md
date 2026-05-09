# GitHub Push Input Checklist for Minh

## GitHub repo input
- repo URL
- private/public
- target branch
- repo naming convention
- ai có quyền push

## Token / auth input
- không paste token vào chat
- không ghi token vào BRD / tasks / log / dashboard
- token chỉ nhập qua env var hoặc secret store
- quyền tối thiểu cần có cho push/commit/tag nếu được approve
- token rotation / revoke note sau khi hoàn tất cấu hình

## Pre-push safety
- dry-run đã pass
- manifest đã có
- secret scan phải pass
- không push `.env`, keys, certs, token, credential
- không push `logs`, `cache`, `tmp`

## Push policy
- commit message format
- tag / version format
- branch target
- có tạo tag hay không
- rollback note

## Schedule policy
- cron `03:00 ICT` và `12:00 ICT` chỉ bật sau khi Minh approve
- hiện tại chỉ là schedule design
- log path cho mỗi lần backup

## Acceptance để mark done
- `bkp-02` done khi repo đích được Minh cung cấp và ghi bằng evidence an toàn, không chứa token
- `bkp-08` done khi push thật có evidence commit / tag, không leak secret
- cron chỉ done nếu Minh approve bật cron

## Current safety lock
- không push GitHub thật trong giai đoạn này
- không dùng token thật trong chat/tool log
- không chuyển sang dashboard cleanup cho tới khi backup GitHub phase hoàn thành
