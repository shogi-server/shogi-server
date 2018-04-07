FROM debian:stretch-slim
MAINTAINER Daigo Moriwaki <daigo@debian.org>

RUN apt-get update && apt-get install -y \
        ca-certificates \
        apt-utils \
        ruby ruby-gsl

ENV EVENT local
ENV PORT 4081
ENV MAX_IDENTIFIER 32

WORKDIR /shogi-server

RUN mkdir /logs
RUN gem install rgl

COPY . ./

EXPOSE $PORT
CMD ./shogi-server --daemon /logs --max-identifier $MAX_IDENTIFIER $EVENT $PORT & tail -F /logs/shogi-server.log
