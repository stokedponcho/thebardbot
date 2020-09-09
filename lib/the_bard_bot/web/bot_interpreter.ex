defmodule TheBardBot.Web.BotInterpreter do
  @type content :: %{}

  @callback read(content :: content()) :: TheBardBot.Core.Messages.Incoming.t()
  @callback write(message :: TheBardBot.Core.Messages.Outgoing.t()) :: tuple()
  @callback write(messages :: list(TheBardBot.Core.Messages.Outgoing.t())) :: tuple()
end
