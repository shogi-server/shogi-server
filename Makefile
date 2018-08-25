
.PHONY: doc
doc: clean
	rdoc --main README -o doc \
	  . shogi-server README mk_html mk_rate csa-file-filter

.PHONY: test-run
test-run:
	./shogi-server --floodgate-games floodgate-600-10,floodgate-3600-0 hoge 4000


.PHONY: test-run-daemon
test-run-daemon:
	./shogi-server --floodgate-games floodgate-600-10,floodgate-3600-0 --daemon . --pid-file ./shogi-server.pid --player-log-dir ./player-logs hoge 4000

.PHONY: stop-daemon
stop-daemon:
	kill `cat shogi-server.pid`

.PHONY: test-time-run
test-time-run:
	ruby -r sample/test_time.rb ./shogi-server --floodgate-games floodgate-900-0,floodgate-3600-0 hoge 4000

.PHONY: image-build
image-build: .image-build
.image-build: Dockerfile
	docker build -t shogiserver/shogiserver:latest -f $< .
	docker images -q shogiserver/shogiserver:latest > $@

.PHONY: clean
clean:
	-rm -rf doc .image-*
