# ---- APplication build stage ----
FROM docker.io/elixir:1.11-alpine as builder

ARG ENV
ARG API_AUTH_HEADER
ARG API_TOKEN

ENV MIX_ENV=$ENV
ENV THEBARDBOT_SLACK_AUTH_HEADER=$API_AUTH_HEADER
ENV THEBARDBOT_SLACK_TOKEN=$API_TOKEN

COPY assets assets
COPY config config
COPY lib lib
COPY mix.exs mix.lock ./

RUN mix local.rebar --force \
	&& mix local.hex --force \
	&& mix deps.get --only $MIX_ENV \
	&& mix do clean, compile --force \
	&& mix release --overwrite

# ---- Dependency build stage ----
FROM docker.io/python:3.8.6-buster as wikiquote

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install --upgrade pip
RUN pip install --upgrade wikiquote

# ---- Application stage ----
FROM docker.io/alpine:latest

ARG ENV

RUN apk add --no-cache --update bash openssl
RUN apk add --no-cache --update python3 libxml2 libxslt

WORKDIR /app

COPY --from=wikiquote /opt/venv /opt/venv
COPY --from=builder _build/$ENV/rel/default/ .

ENV PATH="/opt/venv/bin:$PATH"
ENV PYTHONPATH="/opt/venv/lib/python3.8/site-packages:$PYTHONPATH"

CMD ["/app/bin/default", "start"]
