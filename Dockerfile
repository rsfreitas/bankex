FROM elixir:1.9.0-alpine AS build

# install build dependencies
RUN apk add --update git build-base nodejs yarn python

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get
RUN mix deps.compile

# build project
COPY priv priv
COPY lib lib
RUN mix compile

# build release
COPY rel rel
RUN mix release

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --update bash openssl openrc postgresql-client

RUN mkdir /app
WORKDIR /app

COPY entrypoint.sh .
COPY --from=build /app/_build/prod/rel/bankex ./
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app

CMD ["./entrypoint.sh"]

