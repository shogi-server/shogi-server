#!/usr/bin/env ruby
# Tests that require the server to run with --max-moves 0.
# Each test file is executed in a fresh Ruby interpreter so tests don't share state.
#
# Usage:
#   $ ./shogi-server --max-moves 0 hoge 4000
#   $ cd test && ./TC_ALL_no_max_moves.rb

require 'rbconfig'

TEST_FILES = %w[
  TC_jishogi_kachi.rb
  TC_max_moves_draw.rb
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
