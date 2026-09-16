#!/usr/bin/env python3
"""Local stand-in for the Phoenix Security API, for offline demos of the gate hook.

This exists so `demo-guardrail-enforcement.sh --mode mock` works on a laptop with
no network and no Phoenix token. It serves canned answers on the six endpoints
`scripts/purplephx-gate.sh` calls.

IT IS NOT A SCANNER. Every finding it returns is fixed text from this file. It
proves the ENFORCEMENT MECHANISM works end to end; it proves nothing about the
code being scanned. The demo script says so on screen, and so does this comment.

Two details of the gate's parsing are load-bearing here and must not be "tidied":

  1. Severity is read from runs[].tool.driver.rules[ruleIndex].properties.severity,
     NEVER from the SARIF `level` field (SARIF collapses CRITICAL and HIGH into
     "error"). So every result must carry a valid ruleIndex into a rules[] entry
     that has properties.severity.

  2. A finding counts as NEW only when its artifactLocation.uri is in the gate's
     changedFiles list AND its region.startLine falls inside a `git diff -U0`
     hunk. The demo passes the real path and line in via MOCK_FINDING_PATH /
     MOCK_FINDING_LINE. A wrong line silently yields "0 new findings" — which
     looks like a broken gate but is actually a correct one.

Environment:
  MOCK_PORT            port to listen on              (default 4250)
  MOCK_MODE            ADVISORY | GATE | BLOCK        (default BLOCK)
  MOCK_SEVERITIES      JSON array of blocking sevs    (default ["CRITICAL","HIGH"])
  MOCK_FINDING_PATH    repo-relative path of the finding
  MOCK_FINDING_LINE    1-based line of the finding
  MOCK_STATE_FILE      file whose contents are "vulnerable" or "clean".
                       Re-read on every request, so the demo can flip the answer
                       between two gate runs without restarting the server.
"""

import json
import os
import sys
import datetime
from http.server import BaseHTTPRequestHandler, HTTPServer

PORT = int(os.environ.get("MOCK_PORT", "4250"))
MODE = os.environ.get("MOCK_MODE", "BLOCK")
SEVERITIES = json.loads(os.environ.get("MOCK_SEVERITIES", '["CRITICAL","HIGH"]'))
FINDING_PATH = os.environ.get("MOCK_FINDING_PATH", "src/app.js")
FINDING_LINE = int(os.environ.get("MOCK_FINDING_LINE", "3"))
STATE_FILE = os.environ.get("MOCK_STATE_FILE", "")

# jobId -> the domain object the gate asked for on /execute, so /{jobId} can
# report `completed` for exactly those domains. Reporting a domain the gate did
# not request, or omitting one it did, makes the gate print a coverage warning.
JOBS = {}


def state():
    """'vulnerable' or 'clean'. Read fresh every call — see MOCK_STATE_FILE."""
    if STATE_FILE and os.path.exists(STATE_FILE):
        return open(STATE_FILE).read().strip() or "vulnerable"
    return "vulnerable"


def now():
    return datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def policy():
    return {
        "mode": MODE,
        "blockingSeverities": SEVERITIES,
        "commitDomains": ["SAST", "SECRETS"],
        "pushDomains": ["SAST", "SCA"],
        "updatedAt": now(),
        "source": "MOCK_LOCAL_SERVER",
    }


def sarif():
    """SARIF 2.1.0. Empty results when the state file says the code was fixed."""
    if state() == "clean":
        results = []
    else:
        results = [
            {
                "ruleId": "javascript.browser.security.insecure-innerhtml",
                "ruleIndex": 0,
                "level": "error",
                "message": {
                    "text": (
                        "User controlled data written into '$EL.innerHTML' is an "
                        "anti-pattern that leads to XSS (CWE-79). Use textContent, "
                        "or sanitise with DOMPurify before assignment."
                    )
                },
                "locations": [
                    {
                        "physicalLocation": {
                            "artifactLocation": {"uri": FINDING_PATH},
                            "region": {"startLine": FINDING_LINE},
                        }
                    }
                ],
            }
        ]
    return {
        "version": "2.1.0",
        "$schema": "https://json.schemastore.org/sarif-2.1.0.json",
        "runs": [
            {
                "tool": {
                    "driver": {
                        "name": "Phoenix Security (MOCK)",
                        "rules": [
                            {
                                "id": "javascript.browser.security.insecure-innerhtml",
                                "shortDescription": {"text": "Insecure innerHTML assignment"},
                                # Read by the gate. `level` above is deliberately
                                # not the severity source.
                                "properties": {"severity": "CRITICAL"},
                            }
                        ],
                    }
                },
                "results": results,
            }
        ],
    }


class Handler(BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        sys.stderr.write("[mock-phoenix] %s\n" % (fmt % args))

    def _send(self, code, obj):
        body = json.dumps(obj).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def _path(self):
        return self.path.split("?", 1)[0]

    def _body(self):
        n = int(self.headers.get("Content-Length") or 0)
        if not n:
            return {}
        try:
            return json.loads(self.rfile.read(n) or b"{}")
        except Exception:
            return {}

    def do_GET(self):
        p = self._path()
        if p == "/api/v1/external/purplephx/enforcement-policy":
            return self._send(200, policy())
        if p.startswith("/api/v1/external/pr-scan/"):
            rest = p[len("/api/v1/external/pr-scan/"):]
            if rest.endswith("/sarif"):
                return self._send(200, sarif())
            # Job status. Terminal immediately: the gate polls every 2s and this
            # is a demo, not a load test.
            domains = JOBS.get(rest, {"sast": {"enabled": True}})
            return self._send(200, {
                "jobId": rest,
                "status": "COMPLETED",
                "domainResults": {k: {"status": "completed"} for k in domains},
            })
        return self._send(404, {"error": "not found", "path": p})

    def do_POST(self):
        p = self._path()
        body = self._body()
        if p == "/api/v1/external/pr-scan/resolve":
            return self._send(200, {"bundles": [{"bundleId": "mock-bundle-1", "name": "mock"}]})
        if p == "/api/v1/external/pr-scan/execute":
            job = "mock-job-%s" % datetime.datetime.now().strftime("%H%M%S")
            JOBS[job] = body.get("domains") or {"sast": {"enabled": True}}
            return self._send(200, {"jobId": job})
        if p == "/api/v1/external/purplephx/enforcement-violation":
            # Telemetry sink. The gate ignores the response entirely.
            return self._send(200, {"accepted": True})
        return self._send(404, {"error": "not found", "path": p})


if __name__ == "__main__":
    srv = HTTPServer(("127.0.0.1", PORT), Handler)
    sys.stderr.write(
        "[mock-phoenix] listening on http://127.0.0.1:%d  mode=%s  blocking=%s\n"
        "[mock-phoenix] finding: %s:%d  state-file=%s\n"
        "[mock-phoenix] THIS IS A MOCK. Findings are canned. It proves the hook, not the code.\n"
        % (PORT, MODE, SEVERITIES, FINDING_PATH, FINDING_LINE, STATE_FILE or "(none)")
    )
    srv.serve_forever()
