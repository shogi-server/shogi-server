---
name: test-integration
version: 1.0.0
description: |
  Run the full shogi-server integration test suite (TC_ALL.rb) against a live
  server until it passes 5 consecutive times with no failures, errors, or
  "timed out" messages. Starts the server automatically if it is not already
  listening on port 4000. If a run fails, diagnoses and fixes the root cause
  before re-running.
license: MIT
compatibility: claude-code
allowed-tools:
  - Bash
  - Read
  - Edit
  - Write
  - Grep
  - Glob
---

# Integration test loop

Run the shogi-server integration suite to a high confidence bar: 5 clean passes
in a row, no failures, no errors, no `timed out` in stderr.

## Setup

**Server:** The tests require `./shogi-server` listening on port 4000.
Check whether it is already up before starting a new one.

```bash
ruby -e "require 'socket'; TCPSocket.open('localhost',4000).close; puts 'up'" 2>/dev/null \
  || (./shogi-server --floodgate-games floodgate-600-10,floodgate-3600-0 hoge 4000 \
        &>/tmp/shogi-server.log & sleep 2)
```

**Working directory for test runs:** `test/` inside the repo root.

**Test command:**
```bash
cd /path/to/shogi-server/test && ruby TC_ALL.rb 2>&1
```

## Loop procedure

1. Run the test command. Capture all output (stdout + stderr combined).
2. A run **passes** when the summary line matches:
   `N tests, N assertions, 0 failures, 0 errors` AND no line in the output
   contains `timed out`.
3. A run **fails** otherwise.
4. Keep a **consecutive-pass counter** (starts at 0, resets to 0 on any
   failure). Stop when it reaches **5**.
5. On failure: read the output, identify the root cause, fix the affected
   source files, then re-run immediately (do not increment the counter).
6. Print a one-line status after each run:
   `Pass N/5` or `FAIL — <short diagnosis>`.

## Diagnosing failures

Common failure patterns and their fixes:

| Symptom | Likely cause | Where to look |
|---|---|---|
| `timed out` in reader thread | Orphaned reader thread — `connect` already calls `reader` internally | `test/TC_fork.rb` or other test files calling `.reader` after `.connect` |
| `ECONNREFUSED` on port 4000 | Server not running | Start server (see Setup) |
| `0 tests` or missing test class | Load error in a required file | Check `$:` / require paths |
| Assertion failure | Logic bug or race condition | Read the failing test + server logs in `/tmp/shogi-server.log` |

When the `reader` guard in `baseclient.rb` fires (`reader already running`),
that is always a sign that a test file still has a redundant explicit
`.reader` call after `.connect`. Remove it and its paired `sleep 0.1`.

## Stopping

Omit `ScheduleWakeup` once 5 consecutive passes are recorded.
Report: total runs taken, whether any fixes were needed, and the
final summary line from the last run.
