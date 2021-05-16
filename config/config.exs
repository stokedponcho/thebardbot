import Config

config :the_bard_bot,
  words: "assets/words.csv"

config :the_bard_bot, :bot_interpreter, TheBardBot.Web.BotInterpreter.Slack

config :the_bard_bot, :quote_of_the_day,
  enabled: false,
  run_on_init: false,
  start: ~T[14:00:00],
  interval: 24 * 3_600_000,
  channel: "C8MJS24G2"

config :the_bard_bot, :useless_fact_of_the_day,
  enabled: true,
  run_on_init: false,
  start: ~T[14:00:00],
  interval: 24 * 3_600_000,
  channel: "C8MJS24G2"

config :the_bard_bot, :slack,
  host: "slack.com",
  authorization_header: System.get_env("THEBARDBOT_SLACK_AUTH_HEADER"),
  token: System.get_env("THEBARDBOT_SLACK_TOKEN"),
  content_type: "application/json; charset=utf-8"

config :cowboy,
  port: 4000

config :logger,
  level: :info,
  backends: [:console],
  compile_time_purge_matching: [
    [level_lower_than: :debug]
  ]

import_config("#{Mix.env()}.exs")
