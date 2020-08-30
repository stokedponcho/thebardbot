import Config

config :the_bard_bot, :bot_writer, TheBardBot.BotWriter.Mock

config :logger,
  level: :debug

config :cowboy,
  port: 4010
