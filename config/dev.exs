import Config

config :logger,
  level: :debug,
  compile_time_purge_matching: []

config :the_bard_bot, :quote_of_the_day,
  run_on_init: true,
  channel: "G01A4SY7AMV"

config :the_bard_bot, :useless_fact_of_the_day,
  run_on_init: true,
  channel: "G01A4SY7AMV"
