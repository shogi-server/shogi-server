$topdir = File.expand_path File.dirname(__FILE__)
require_relative "baseclient"
include Socket::Constants

# This game has more thatn 256 moves.
# Disableing max-moves, "./shogi-server --max moves 0", is required.

class JishogiTest < ReadFileClient
  def test_jishogi_kachi
    csa = File.open(filepath("jishogi_kachi.csa")) {|f| f.read}
    handshake(csa)
    @p2.puts "%KACHI"
    @p1.wait(/#JISHOGI\n#LOSE/)
    @p2.wait(/#JISHOGI\n#WIN/)
    assert true
    logout12
  end
end # Client class
