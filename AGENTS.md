# AGENTS.md

## Project

Shogi-server is a Ruby server implementing the Computer Shogi Association (CSA) Server Protocol v1.2.1, letting computer shogi programs connect over TCP and play rated or Floodgate (automated pairing) games. Requires Ruby 3.2+. No gem bundling — it runs straight from the source tree.

## Common commands

Run the server locally (the argument `hoge` is an arbitrary event name / log prefix; 4000 is the port):

```
./shogi-server hoge 4000
```

Makefile shortcuts (see `Makefile`):

- `make test-run` — run with Floodgate groups `floodgate-600-10,floodgate-3600-0` on port 4000
- `make test-run-daemon` / `make stop-daemon` — daemon mode writing to `./shogi-server.pid` and `./player-logs/`

## Running tests

The functional tests require a **running server** on port 4000 — start one first in another terminal, then:

```
cd test && ruby TC_ALL.rb
```

Run a single test file: `ruby test/TC_board.rb` (files are loaded via `$:.unshift` so they work from either `test/` or the repo root). `TC_ALL.rb` explicitly skips `TC_jishogi_kachi` because it exceeds the 256-move default — run it separately against a server started with `--max-moves 0`.

Tests use `test/baseclient.rb` + `test/mock_player.rb` to speak CSA protocol to the live server; they also read/write log files under the server's working directory, so the server and the tests must share the same cwd.

## Architecture

Entry points:

- `shogi-server` — executable script; parses CLI options, sets up `$logger`/`$league`/`$config`, opens the listen socket (IPv4 + IPv6), and spawns one thread per accepted client.
- `shogi_server.rb` — top-level `ShogiServer` module; requires the subcomponents and defines `Revision`, `Default_*` constants, `reload` (hot-reloads Floodgate/pairing/persistent-league code on each accept), and `available?` (honors the `STOP` file for graceful shutdown).

Core domain lives in `shogi_server/`:

- `board.rb`, `piece.rb`, `move.rb`, `handicapped_boards.rb` — rules engine (legality, sennichite, uchifuzume, jishogi kachi, etc.).
- `game.rb`, `game_result.rb`, `time_clock.rb` — per-match state machine, clocks, CSA record writing.
- `player.rb`, `login.rb`, `command.rb` — per-connection player object and CSA command dispatch.
- `league.rb` + `league/persistent.rb` — rated league with YAML-backed persistent ratings.
- `league/floodgate.rb`, `league/floodgate_thread.rb`, `pairing.rb`, `buoy.rb` — Floodgate automated pairing: a background thread wakes at scheduled times (from `<game_name>.conf` files in the working dir), selects a `pairing_factory`, and starts matches. The pairing/floodgate files are listed in `RELOAD_FILES` and `ShogiServer.reload` re-`load`s them on each accept so operators can edit them without restarting.
- `usi.rb` + `bin/usiToCsa.rb` — USI ↔ CSA bridge so USI engines can participate.
- `config.rb`, `util.rb`, `compatible.rb`, `timeout_queue.rb` — shared utilities and Ruby-version shims.

Auxiliary top-level scripts (each self-documented in its header): `mk_rate` (rating computation), `mk_html` (HTML report generation), `mk_game_results`, `showgame/`, `csa-file-filter`, `utils/` (graphing, stats). `webserver/` is a separate WEBrick-based companion UI.

## Operational notes that affect code changes

- **STOP file**: `ShogiServer.available?` checks `./STOP`. Creating it blocks new games (including Floodgate); the server deletes it on startup. Any code that starts a new game should go through this gate.
- **Floodgate config reload**: `<game_name>.conf` is re-read once just after each game starts, and `RELOAD_FILES` are re-`load`ed on each accept — keep those files reload-safe (no top-level side effects that can't be repeated).
- **CSA record compatibility**: move/board formatting is consumed by external tools and recorded games; changes to output format will break downstream parsers and the functional tests under `test/csa/`.
- **Revision constant**: `ShogiServer::Revision` in `shogi_server.rb` is bumped per release (current: `20201206`) and printed in `--help`.
