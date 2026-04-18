require_relative 'test_setup'
require_relative "baseclient"
include Socket::Constants

# This game reaches exactly 256 moves, triggering the server's #MAX_MOVES draw.
# Requires the default server (--max-moves 256); do NOT run with --max-moves 0.

class MaxMovesTest < ReadFileClient
  def test_max_moves_draw
    csa = File.open(filepath("max_moves_draw.csa")) {|f| f.read}
    handshake(csa)
    @p1.wait(/#MAX_MOVES\n#CENSORED/)
    @p2.wait(/#MAX_MOVES\n#CENSORED/)
    assert true
    logout12
  end
end # Client class
