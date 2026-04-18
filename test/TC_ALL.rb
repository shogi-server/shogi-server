#!/usr/bin/env ruby
# Runs each test file in a fresh Ruby interpreter so tests don't share state.

require 'rbconfig'

TEST_FILES = %w[
  TC_board.rb
  TC_before_agree.rb
  TC_buoy.rb
  TC_command.rb
  TC_compatible.rb
  TC_config.rb
  TC_floodgate.rb
  TC_floodgate_history.rb
  TC_floodgate_next_time_generator.rb
  TC_floodgate_thread.rb
  TC_fork.rb
  TC_functional.rb
  TC_game.rb
  TC_game_least_0.rb
  TC_game_result.rb
  TC_handicapped_boards.rb
  TC_max_moves_draw.rb
  TC_league.rb
  TC_logger.rb
  TC_login.rb
  TC_move.rb
  TC_not_sennichite.rb
  TC_oute_sennichite.rb
  TC_pairing.rb
  TC_player.rb
  TC_rating.rb
  TC_time_clock.rb
  TC_uchifuzume.rb
  TC_usi.rb
  TC_util.rb
]
dir = __dir__
failed = []
TEST_FILES.each do |tc|
  puts "=== #{tc} ==="
  system(RbConfig.ruby, File.join(dir, tc)) || failed << tc
end

puts
if failed.empty?
  puts "OK: #{TEST_FILES.size} test files passed."
  exit 0
else
  puts "FAIL: #{failed.size}/#{TEST_FILES.size}: #{failed.join(', ')}"
  exit 1
end
