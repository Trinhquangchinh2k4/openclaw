# Apple Watch Assistant Architecture v0.1

## 1. Goal / MVP

Build an Apple Watch Assistant MVP for Apple Watch Series 4-class constraints: push-to-talk voice capture, Vietnamese STT, assistant response, text display on watch, optional TTS playback, and safe backend-mediated model/API access.

Current Linux/VPS host can continue backend/mock/spec work. Real watchOS simulator or device build requires a Mac/Xcode runner and Apple signing inputs.

## 2. In Scope v1

- watchOS app UI for push-to-talk, response display, mode toggle, and basic session status.
- iPhone companion app if needed for audio/network relay, auth bootstrap, and configuration.
- Backend assistant service with text and voice endpoints.
- OpenClaw gateway/API integration through a dedicated Apple Watch assistant path.
- Vietnamese STT/TTS integration as replaceable providers.
- Token/config storage split between dev and production.
- Ops Cockpit monitoring for health, metrics, sessions, token usage, and lock isolation status.
- Backend mock that can run on Linux/VPS before Mac/Xcode availability.

## 3. Out Of Scope v1

- Fully local model execution on Apple Watch.
- Offline STT/TTS on watch.
- Production App Store release automation.
- Multi-user enterprise account management.
- Long-running background listening.
- Secret display in watch app, iPhone frontend, or dashboard.

## 4. Component Map

- watchOS app: captures user action/audio, shows assistant text response, handles voice/text mode, displays network/session errors.
- iPhone companion app: optional relay/config layer for network/auth and larger audio buffering when watchOS constraints require it.
- backend assistant service: owns `/assistant/*` API, request validation, session routing, model calls, STT/TTS orchestration, and response normalization.
- OpenClaw gateway/API: provides assistant model access and team runtime integration, but Apple Watch path must not acquire the main session write lock.
- voice/STT/TTS layer: accepts audio payloads, returns transcript, optionally renders TTS audio; provider is configurable.
- token/config storage: server-side only for model/STT/TTS secrets; watch/iPhone receive only scoped runtime config or opaque session credentials.
- dashboard monitoring: Ops Cockpit reads health/metrics and shows Apple Watch runtime isolation, token usage, and alert status.

## 5. Data Flow

1. Watch -> iPhone/backend:
   - Text mode: watch sends text directly or through iPhone relay to `POST /assistant/message`.
   - Voice mode: watch records audio and sends it directly or through iPhone relay to `POST /assistant/voice`.
2. Backend -> model/API:
   - Backend validates request, selects isolated Apple Watch session/log path, calls STT if audio, then routes text to model/API.
3. Response -> Watch:
   - Backend returns normalized response text, session id, optional TTS URL/base64, and status metadata.
   - Watch displays text and plays audio only when voice mode is enabled.
4. Logs/metrics -> Ops Cockpit:
   - Backend writes Apple Watch-specific logs/metrics under an isolated project/session path.
   - Ops Cockpit reads `/health`, `/metrics`, and session metadata without requiring the main session write lock.

## 6. API Contract v0.1

### `POST /assistant/message`

Request:

```json
{
  "sessionId": "optional-client-session-id",
  "text": "Xin chao",
  "mode": "text|voice",
  "locale": "vi-VN",
  "client": {
    "device": "watchOS",
    "appVersion": "0.1.0"
  }
}
```

Response:

```json
{
  "ok": true,
  "sessionId": "apple-watch-assistant",
  "replyText": "Noi dung phan hoi",
  "replyAudioUrl": null,
  "metrics": {
    "inputTokens": 0,
    "outputTokens": 0,
    "totalTokens": 0
  }
}
```

### `POST /assistant/voice`

Request:

```json
{
  "sessionId": "optional-client-session-id",
  "audioBase64": "...",
  "format": "m4a|wav|caf",
  "locale": "vi-VN",
  "mode": "voice|text"
}
```

Response:

```json
{
  "ok": true,
  "sessionId": "apple-watch-assistant",
  "transcript": "Noi dung nhan dang",
  "replyText": "Noi dung phan hoi",
  "replyAudioUrl": null
}
```

### `GET /assistant/session/:id`

Response:

```json
{
  "ok": true,
  "sessionId": "apple-watch-assistant",
  "status": "active|idle|error",
  "lastUpdated": null,
  "logPath": "/root/.openclaw/workspace/projects/apple-watch-assistant/runtime/logs/apple-watch-assistant.jsonl"
}
```

### `GET /health`

Response:

```json
{
  "ok": true,
  "service": "apple-watch-assistant",
  "version": "0.1.0",
  "mainSessionLockBlocking": false
}
```

### `GET /metrics`

Response:

```json
{
  "ok": true,
  "sessions": 0,
  "requests": 0,
  "errors": 0,
  "inputTokens": 0,
  "outputTokens": 0,
  "totalTokens": 0
}
```

## 7. Runtime Decision

- Apple Watch does not depend on the main session lock.
- Default runtime path uses isolated session id `apple-watch-assistant`.
- Logs should be written to a dedicated path, for example `/root/.openclaw/workspace/projects/apple-watch-assistant/runtime/logs/apple-watch-assistant.jsonl`.
- Read-only snapshots of main context are allowed when needed, but Apple Watch requests must not acquire the main session write lock.

## 8. Security / Token

- Do not hardcode secrets in watchOS app, iPhone app, or frontend dashboard.
- Split config into dev and prod.
- Store model/STT/TTS secrets only on the backend or secure deployment environment.
- Dashboard may show token usage counts and `tokenActive`, but must never show secret values.
- Bundle IDs and public app metadata can be documented; private certificates, provisioning profiles, and API keys must not be committed.

## 9. Acceptance Checklist

- [x] Architecture v0.1 file exists.
- [ ] Backend mock exposes `POST /assistant/message`.
- [ ] Backend mock exposes `POST /assistant/voice`.
- [ ] Backend mock exposes `GET /assistant/session/:id`.
- [ ] Backend mock exposes `GET /health`.
- [ ] Backend mock exposes `GET /metrics`.
- [ ] Apple Watch backend path uses isolated session/log path.
- [ ] Ops Cockpit shows Apple Watch lock isolation status.
- [ ] Simulator/dev build path documented.
- [ ] Real device/TestFlight signing inputs documented.
- [ ] Mac/Xcode runner available for watchOS build.

## Host Constraint

Current non-Mac/Linux host does not block backend/mock/spec work. It only blocks local watchOS simulator build and real device/TestFlight build until Mac/Xcode/signing inputs are available.
