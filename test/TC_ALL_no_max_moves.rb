# Tests that require the server to run with --max-moves 0.
# Usage:
#   $ ./shogi-server --max-moves 0 hoge 4000
#   $ cd test && ruby TC_ALL_no_max_moves.rb
require_relative 'TC_jishogi_kachi'
