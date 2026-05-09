# Apple Watch Assistant — BRD update

- Version: v2 draft
- File: `090743_27042026_apple-watch-assistant.md`
- Project: `apple-watch-assistant`
- Priority: P0
- Owner: main
- Assignee routes: manh (/devlead), huy (/frontend), ha (/backend), huyen (/ba)
- Model policy: `9router/cx/gpt-5.4`

## Outcome
Đưa Apple Watch Assistant thành project P0 với task source-of-truth thật, hướng tới bản đầu tiên cài/chạy thử được trên Apple Watch hoặc simulator, có voice assistant tiếng Việt và acceptance checklist rõ ràng.

## Scope adjustments after user acceptance
1. Output cuối phải là app/package/solution cài được.
2. Không làm backup trước Apple Watch.
3. Dashboard phải hiển thị project metadata thật: priority P0, done/total, %, owner/assignee/executor, next action, latest BRD path, blocker.
4. Build path ưu tiên Watch app + iPhone companion + backend assistant.

## MVP workstreams
### /pm main
- chốt scope MVP
- giữ source-of-truth tasks + BRD
- điều phối blocker/signoff

### /devlead manh
- architecture watchOS/iPhone/backend
- install/run-test path
- dependency/risk register

### /frontend huy
- watch/iPhone UX flow + skeleton structure

### /backend ha
- voice assistant tiếng Việt
- auth/token/config an toàn
- backend contract

### /ba huyen
- acceptance checklist
- test scenarios
- BRD/UAT updates

## Initial acceptance checklist for first runnable build
- Có skeleton project structure rõ watch/iPhone/backend
- Có hướng dẫn chạy simulator hoặc watch test
- Có push-to-talk flow đã thiết kế
- Có response text trên watch UI path
- Có quyết định voice/silent mode
- Không để lộ API key/token ở client
- Có checklist smoke test lần đầu

## Current blockers
- Chưa có architecture spec cuối cùng.
- Chưa xác nhận signing/Xcode path.
- Gateway/session lock còn ảnh hưởng backend realtime path.

## Next action
Tạo architecture spec + skeleton plan trước khi bắt đầu build thật.
