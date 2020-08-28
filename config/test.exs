import Config

config :the_bard_bot, :bot_user, TheBardBot.BotUser.Mock

config :logger,
  level: :debug

config :cowboy,
  port: 4010
