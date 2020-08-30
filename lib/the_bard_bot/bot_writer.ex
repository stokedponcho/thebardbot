defmodule TheBardBot.BotWriter do
  @callback write(message :: TheBardBot.Messages.Outgoing) :: tuple()
end
