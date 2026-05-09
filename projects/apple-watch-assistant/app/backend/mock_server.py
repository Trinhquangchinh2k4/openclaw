#!/usr/bin/env python3
import json
from datetime import datetime, timezone
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse

SESSIONS = {}
REQUESTS_TOTAL = 0
PROJECT_ID = "apple-watch-assistant"
RUNTIME_ISOLATION = "isolated-session"


def now_iso():
    return datetime.now(timezone.utc).isoformat()


class Handler(BaseHTTPRequestHandler):
    def _send(self, code, payload):
        body = json.dumps(payload, ensure_ascii=False).encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def _read_json(self):
        length = int(self.headers.get("Content-Length", "0") or 0)
        raw = self.rfile.read(length) if length else b"{}"
        return json.loads(raw.decode("utf-8"))

    def do_GET(self):
        global REQUESTS_TOTAL
        REQUESTS_TOTAL += 1
        path = urlparse(self.path).path
        if path == "/health":
            return self._send(200, {
                "ok": True,
                "service": PROJECT_ID,
                "sessionIsolation": RUNTIME_ISOLATION,
                "time": now_iso(),
            })
        if path == "/metrics":
            return self._send(200, {
                "ok": True,
                "projectId": PROJECT_ID,
                "activeSessions": len(SESSIONS),
                "requestsTotal": REQUESTS_TOTAL,
                "lastUpdated": now_iso(),
                "runtimeIsolation": RUNTIME_ISOLATION,
            })
        if path.startswith("/assistant/session/"):
            session_id = path.rsplit("/", 1)[-1]
            session = SESSIONS.get(session_id, {"messages": [], "status": "new", "updatedAt": now_iso()})
            return self._send(200, {
                "ok": True,
                "sessionId": session_id,
                "messages": session.get("messages", []),
                "status": session.get("status", "new"),
                "updatedAt": session.get("updatedAt", now_iso()),
            })
        return self._send(404, {"ok": False, "error": "not_found"})

    def do_POST(self):
        global REQUESTS_TOTAL
        REQUESTS_TOTAL += 1
        path = urlparse(self.path).path
        data = self._read_json()
        if path == "/assistant/message":
            session_id = data.get("sessionId") or "mock-session"
            msg = data.get("message") or ""
            row = {"role": "user", "text": msg, "time": now_iso()}
            SESSIONS.setdefault(session_id, {"messages": [], "status": "active", "updatedAt": now_iso()})
            SESSIONS[session_id]["messages"].append(row)
            SESSIONS[session_id]["messages"].append({"role": "assistant", "text": f"Mock reply to: {msg}", "time": now_iso()})
            SESSIONS[session_id]["status"] = "active"
            SESSIONS[session_id]["updatedAt"] = now_iso()
            return self._send(200, {
                "ok": True,
                "sessionId": session_id,
                "replyText": f"Mock reply to: {msg}",
                "replyAudioUrl": None,
                "source": "mock_server",
            })
        if path == "/assistant/voice":
            session_id = data.get("sessionId") or "mock-session"
            transcript = "Mock transcript"
            SESSIONS.setdefault(session_id, {"messages": [], "status": "active", "updatedAt": now_iso()})
            SESSIONS[session_id]["messages"].append({"role": "user", "text": transcript, "time": now_iso()})
            SESSIONS[session_id]["messages"].append({"role": "assistant", "text": "Mock voice reply", "time": now_iso()})
            SESSIONS[session_id]["status"] = "active"
            SESSIONS[session_id]["updatedAt"] = now_iso()
            return self._send(200, {
                "ok": True,
                "sessionId": session_id,
                "transcript": transcript,
                "replyText": "Mock voice reply",
                "replyAudioUrl": None,
            })
        return self._send(404, {"ok": False, "error": "not_found"})


if __name__ == "__main__":
    server = HTTPServer(("127.0.0.1", 18795), Handler)
    print("Mock Apple Watch Assistant server listening on http://127.0.0.1:18795")
    server.serve_forever()
