# ---- Build stage ----
FROM elixir:1.9-alpine as builder

ARG ENV=prod

ENV MIX_ENV=$ENV

COPY assets assets
COPY config config
COPY lib lib
COPY mix.exs mix.lock ./

RUN mix local.rebar --force \
	&& mix local.hex --force \
	&& mix local.hex --force \
	&& mix deps.get --only $MIX_ENV \
	&& mix do clean, compile --force \
	&& mix release --overwrite

# ---- Application stage ----
FROM alpine:latest

RUN apk add --no-cache --update bash openssl

WORKDIR /app

COPY --from=builder _build/prod/rel/default/ .

CMD ["/app/bin/default", "start"]
