defmodule TheBardBot.BotReader do
  @type content :: %{}
  @callback read(content :: content()) :: TheBardBot.Messages.Incoming
end
