# Shogi-server project

The Shogi-server project develops Shogi-server, a rating tool and so on.

## Shogi-server

Shogi-server implements
[the Server Protocol](https://www.computer-shogi.org/protocol/) Ver 1.2.1 defined
by [Computer Shogi Association(http://www.computer-shogi.org/index_e.html)
for computer shogi programs to play games.

### Pre-requires

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

## Other tools

See documents at the head of each source file.

- mk_rate
- mk_html
- showgame

## Tests

Run the server

```sh
$ ./shogi-server hoge 4000
```

Run test cases

```sh
$ cd test
$ ruby TC_ALL.rb
```

Some tests (e.g. jishogi_kachi) require the server to run with `--max-moves 0`
because the games exceed the default 256-move limit.

```sh
$ ./shogi-server --max-moves 0 hoge 4000
$ cd test
$ ruby TC_ALL_no_max_moves.rb
```