---
name: test-integration
version: 1.1.0
description: |
  Run the full shogi-server integration test suites against a live server
  until each passes 5 consecutive times with no failures, errors, or
  "timed out" messages.

  Phase 1: TC_ALL.rb with the default server.
  Phase 2: TC_ALL_no_max_moves.rb with a --max-moves 0 server.

  Starts the server automatically if it is not already listening on port 4000.
  If a run fails, diagnoses and fixes the root cause before re-running.
license: MIT
compatibility: claude-code
allowed-tools:
  - Bash(ruby -e "require 'socket'*)
  - Bash(./shogi-server*)
  - Bash(pkill -f 'shogi-server*)
  - Bash(sleep *)
  - Bash(cd */test && ruby TC_ALL*)
  - Bash(ruby TC_ALL.rb*)
  - Bash(ruby TC_ALL_no_max_moves.rb*)
  - Read
  - Edit
  - Write
  - Grep
  - Glob
---

# Integration test loop

Run the shogi-server integration suites: 5 clean passes in a row per phase,
no failures, no errors, no `timed out` in stderr.

Two phases, run sequentially. Port 4000 is hardcoded in the test client, so
only one server can run at a time:

| Phase | Server flags | Test file |
|-------|-------------|-----------|
| 1 | (default) | `TC_ALL.rb` |
| 2 | `--max-moves 0` | `TC_ALL_no_max_moves.rb` |

## Setup

### Phase 1 server (default)

```bash
ruby -e "require 'socket'; TCPSocket.open('localhost',4000).close; puts 'up'" 2>/dev/null \
  || (./shogi-server hoge 4000 &>/tmp/shogi-server.log & sleep 2)
```

### Phase 2 server (no max moves)

Kill any existing server on port 4000 first, then start with `--max-moves 0`:

```bash
pkill -f 'shogi-server.*4000' 2>/dev/null; sleep 1
./shogi-server --max-moves 0 hoge 4000 \
  &>/tmp/shogi-server-no-max-moves.log & sleep 2
```

**Working directory for test runs:** `test/` inside the repo root.

### Test commands

- Phase 1: `cd /path/to/shogi-server/test && ruby TC_ALL.rb 2>&1`
- Phase 2: `cd /path/to/shogi-server/test && ruby TC_ALL_no_max_moves.rb 2>&1`

## Loop procedure

1. Run the Phase 1 test command. Capture all output (stdout + stderr combined).
2. A run passes when the summary line matches
   `N tests, N assertions, 0 failures, 0 errors` AND no line in the output
   contains `timed out`.
3. A run fails otherwise.
4. Keep a consecutive-pass counter (starts at 0, resets to 0 on any failure).
   Stop the current phase when it reaches 5.
5. On failure: read the output, identify the root cause, fix the affected
   source files, then re-run immediately (do not increment the counter).
6. Print a one-line status after each run:
   `Phase N: Pass M/5` or `Phase N: FAIL — <short diagnosis>`.
7. When Phase 1 reaches 5 consecutive passes, transition to Phase 2:
   - Kill the Phase 1 server.
   - Start the Phase 2 server (see Setup above).
   - Reset the consecutive-pass counter to 0.
   - Run Phase 2 with the same pass/fail logic.
8. When Phase 2 reaches 5 consecutive passes, kill the server and stop.

```bash
pkill -f 'shogi-server.*4000' 2>/dev/null; true
```

## Diagnosing failures

Common failure patterns and their fixes:

| Symptom | Likely cause | Where to look |
|---|---|---|
| `timed out` in reader thread | Orphaned reader thread — `connect` already calls `reader` internally | `test/TC_fork.rb` or other test files calling `.reader` after `.connect` |
| `ECONNREFUSED` on port 4000 | Server not running | Start server (see Setup) |
| `0 tests` or missing test class | Load error in a required file | Check `$:` / require paths |
| Assertion failure | Logic bug or race condition | Read the failing test + server logs in `/tmp/shogi-server.log` or `/tmp/shogi-server-no-max-moves.log` |

When the `reader` guard in `baseclient.rb` fires (`reader already running`),
that is always a sign that a test file still has a redundant explicit
`.reader` call after `.connect`. Remove it and its paired `sleep 0.1`.

## Stopping

Omit `ScheduleWakeup` once both phases have recorded 5 consecutive passes.
Report: total runs taken per phase, whether any fixes were needed, and the
final summary line from the last run of each phase.
