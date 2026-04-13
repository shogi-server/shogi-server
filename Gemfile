source 'https://rubygems.org'

ruby '>= 3.2.3'

# Required by `shogi-server` (via shogi_server.rb, which uses
# WEBrick::GenericServer / WEBrick::Daemon) and by the standalone
# `webserver` script. WEBrick was removed from the Ruby standard library
# in Ruby 3.0 and is now distributed as a gem.
gem 'webrick'

# Beyond webrick, the core `shogi-server` binary and everything under
# `shogi_server/` rely only on the standard library.
#
# The following are needed only if you run the corresponding auxiliary
# scripts; install them ad-hoc rather than burdening every deployment:
#   * mk_rate               -> gem 'rgl', gem 'gsl'
#   * utils/eval_graph.rb   -> gem 'gnuplot'
#   * utils/players_graph.rb-> gem 'gnuplot'
#   * shogi-server-profile  -> gem 'ruby-prof'
#   * showgame/             -> gem 'ramaze', gem 'thrift'
#   * test/ (Test::Unit)    -> gem 'test-unit'
