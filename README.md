# Shogi-server project

The Shogi-server project develops Shogi-server, a rating tool and so on.

## Shogi-server

Shogi-server implements
[the Server Protocol](https://www.computer-shogi.org/protocol/) Ver 1.2.1 defined
by [Computer Shogi Association](http://www.computer-shogi.org/index_e.html)
for computer shogi programs to play games.

### Prerequisites

Ruby 3.2 or later

For Debian,

```sh
$ sudo apt install ruby
```

### Install

```sh
$ git clone https://github.com/shogi-server/shogi-server.git
```

The following files are required to run Shogi-server:

- shogi-server
- shogi_server.rb
- shogi_server/
- shogi_server/**/*.rb

### Run

Examples:

Run the server with CSA Protocol V1.2 or later

```sh
$ ./shogi-server hoge 4081
```

With CSA Protocol V1.1.2 or before

```sh
$ ./shogi-server --max-moves 0 --least-time-per-move 1 hoge 4081
```

See others written in the 'shogi-server' file.

## Docker

The repo includes a Dockerfile that installs Ruby and dependencies on Debian Trixie.
The server runs on port 4081 by default; logs go to `/logs`.

```sh
$ docker build -t shogiserver/shogiserver:latest .
$ docker run -p 4081:4081 shogiserver/shogiserver:latest
```

Environment variables:

| Variable          | Default  | Description                       |
|-------------------|----------|-----------------------------------|
| `EVENT`           | `local`  | Event name passed to shogi-server |
| `PORT`            | `4081`   | Port the server listens on        |
| `MAX_IDENTIFIER`  | `32`     | Maximum length of player IDs      |

## Other tools

See documents at the head of each source file.

- mk_rate
- mk_html
- showgame

## Tests

Run the server first (`make test-run` also enables floodgate games):

```sh
$ ./shogi-server hoge 4000
# or
$ make test-run
```

Run tests:

```sh
$ cd test
$ ruby TC_ALL.rb
```

Some tests (e.g. jishogi_kachi) need `--max-moves 0`; they exceed the default 256-move limit.

```sh
$ ./shogi-server --max-moves 0 hoge 4000
# or
$ make test-run-no-max-moves
$ cd test
$ ruby TC_ALL_no_max_moves.rb
```

To run the server as a daemon:

```sh
$ make test-run-daemon
$ make stop-daemon
```
