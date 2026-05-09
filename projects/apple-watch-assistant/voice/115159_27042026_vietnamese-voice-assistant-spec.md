# Apple Watch Assistant MVP Readiness - Vietnamese Voice Assistant Spec

## Interaction model
- user speaks or types in Vietnamese
- watch receives text/voice input
- backend returns short responses suitable for Apple Watch screen size
- sensitive actions require confirmation before execution

## STT / TTS decision
### Phase VPS/mock
- text-first
- voice path remains placeholder/mock contract
- backend MVP is not blocked by missing real-device voice runtime

### Phase Mac/iOS/watchOS
- use Apple Speech / `SFSpeechRecognizer` or dictation path if appropriate for watchOS+iPhone companion flow
- TTS may use iOS/watchOS speech output or text-only response depending on MVP constraints

## Response style
- short
- Vietnamese
- confirm before sensitive actions
- do not return long answers on watch screen

## API mapping
### POST /assistant/message
Request:
- `sessionId`: string
- `message`: string
- `client`: `watchos | iphone | web`
- `mode`: `text | voice`

Response:
- `ok`: boolean
- `sessionId`: string
- `replyText`: string
- `replyAudioUrl`: string|null
- `source`: string

### POST /assistant/voice
Request:
- `sessionId`: string
- `audioBase64`: string
- `audioFormat`: string
- `client`: string

Response:
- `ok`: boolean
- `sessionId`: string
- `transcript`: string
- `replyText`: string
- `replyAudioUrl`: string|null

## Error handling
- network error
- no microphone permission
- speech unavailable
- backend timeout
- token/config missing

## Acceptance
- can be mocked by text on VPS
- voice path does not block backend MVP
- do not claim real-device voice until Mac/Xcode/watchOS runtime exists

## Related files
- API contract: `/root/.openclaw/workspace/projects/apple-watch-assistant/app/backend/api_contract.md`
- install/run path: `/root/.openclaw/workspace/projects/apple-watch-assistant/install-run/115159_27042026_install-run-test-path.md`
- BRD baseline: `/root/.openclaw/workspace/projects/apple-watch-assistant/brd/103100_27042026_apple-watch-assistant.md`
