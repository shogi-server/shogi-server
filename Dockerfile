FROM debian
MAINTAINER Daigo Moriwaki <daigo@debian.org>

RUN apt-get update && apt-get install -y \
        apt-utils \
        ruby ruby-gsl
RUN gem install rgl

ENV EVENT local
ENV PORT 4081
ENV MAX_IDENTIFIER 32

WORKDIR /shogi-server
CMD mkdir $WORKDIR
CMD mkdir /logs

COPY . ./

CMD ./shogi-server --daemon /logs --pid-file shogi-server.pid --max-identifier $MAX_IDENTIFIER $EVENT $PORT && tail -F /logs/shogi-server.log

