import Config

config :the_bard_bot, :bot_interpreter, TheBardBot.Web.BotInterpreter.Mock

config :logger,
  level: :debug

config :cowboy,
  port: 4010
