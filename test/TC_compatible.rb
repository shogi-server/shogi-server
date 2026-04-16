require 'test/unit'
require_relative '../shogi_server'
require_relative '../shogi_server/compatible'

class TestCompatibleArray < Test::Unit::TestCase
  def test_sample
    assert [1,2].include?([1,2].sample)
  end
end
