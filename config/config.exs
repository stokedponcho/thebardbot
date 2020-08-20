import Config

config :the_bard_bot,
  words: "assets/words.csv"

config :cowboy,
  port: 4000

config :logger,
  level: :info,
  backends: [:console],
  compile_time_purge_level: :debug

import_config("#{Mix.env()}.exs")
