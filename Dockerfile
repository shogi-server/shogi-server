FROM debian:trixie-slim
LABEL maintainer="Daigo Moriwaki <daigo@debian.org>"

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        bundler \
        ruby \
        ruby-gsl \
    && rm -rf /var/lib/apt/lists/*

ENV EVENT=local
ENV PORT=4081
ENV MAX_IDENTIFIER=32

WORKDIR /shogi-server

RUN mkdir /logs

COPY Gemfile ./
RUN bundle install

RUN gem install rgl

COPY . ./

EXPOSE $PORT
CMD ["sh", "-c", "./shogi-server --daemon /logs --max-identifier $MAX_IDENTIFIER $EVENT $PORT & tail -F /logs/shogi-server.log"]
