import Config

config :the_bard_bot,
  words: "assets/words.csv"

config :the_bard_bot, :bot_writer, TheBardBot.BotWriter.Slack
config :the_bard_bot, :bot_reader, TheBardBot.BotReader.Slack

config :the_bard_bot, :slack,
  host: "",
  authorization_header: "",
  content_type: "application/json"

config :cowboy,
  port: 4000

config :logger,
  level: :info,
  backends: [:console],
  compile_time_purge_level: :debug

import_config("#{Mix.env()}.exs")
