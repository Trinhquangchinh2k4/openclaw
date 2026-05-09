# API Contract v0.2

## Live Apple Watch Channel

### `POST /api/channels/apple-watch/message`

This is the compatibility endpoint for the current iPhone bridge / watchOS app.
It runs inside Ops Cockpit and adapts Apple Watch payloads to the existing live
OpenClaw `/api/voice-chat` pipeline.

#### Auth

Development auth accepts either:

- Basic auth using `BASIC_AUTH_USER` / `BASIC_AUTH_PASS` from
  `/root/.openclaw/ops-cockpit/ops-cockpit.env`
- Bearer token using `APPLE_WATCH_CHANNEL_TOKEN`; if unset, it falls back to
  `gateway.auth.token` from `/root/.openclaw/openclaw.json`

Clients should send one of:

```http
Authorization: Basic <base64-user-pass>
```

or:

```http
Authorization: Bearer <apple-watch-channel-token>
```

#### Text Request

Content-Type: `application/json`

```json
{
  "channel": "apple_watch",
  "message": "noi dung user",
  "inputType": "text",
  "locale": "vi-VN",
  "deviceId": "iphone-or-watch-device-id",
  "conversationId": "conversation-id",
  "metadata": {
    "platform": "watchos",
    "via": "iphone_bridge",
    "watchSupportsAudio": true,
    "watchSupportsImages": true
  }
}
```

Adapter call to live OpenClaw:

```json
{
  "agentId": "main",
  "text": "noi dung user",
  "suffix": "",
  "timeout": 60
}
```

#### Audio Request

Content-Type: `multipart/form-data`

Fields:

- `payload`: JSON object matching the text request, with `inputType = "audio"`
- `audio`: audio file, normally `.m4a` with MIME type `audio/m4a`

Adapter call to live OpenClaw:

```json
{
  "agentId": "main",
  "audioBase64": "<base64-audio>",
  "text": "optional payload.message",
  "suffix": ".m4a",
  "timeout": 120
}
```

#### Response

The endpoint normalizes the live `replyText` / `tts.audioPath` response into the
format expected by the iPhone app:

```json
{
  "reply": "assistant reply text",
  "message": "assistant reply text",
  "text": "assistant reply text",
  "output": "assistant reply text",
  "images": [],
  "imageUrls": [],
  "audioUrl": "https://host/uploads/file.mp3"
}
```

If TTS is unavailable or no audio is produced, `audioUrl` is `null`. Relative
`tts.audioPath` values are converted to an absolute URL using the incoming
request host/protocol, including Cloudflare tunnel headers.

## Legacy Mock Contract

The older Linux/VPS mock remains available as a local reference only:

- `POST /assistant/message`
- `POST /assistant/voice`
- `GET /assistant/session/:id`
- `GET /health`
- `GET /metrics`

The mock server is not the production Apple Watch channel endpoint.
