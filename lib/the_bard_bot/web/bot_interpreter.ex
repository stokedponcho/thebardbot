defmodule TheBardBot.Web.BotInterpreter do
  @type content :: %{}

  @callback read(content :: content()) :: TheBardBot.Core.Messages.Incoming
  @callback write(message :: TheBardBot.Core.Messages.Outgoing) :: tuple()
  @callback write(messages :: list(TheBardBot.Core.Messages.Outgoing)) :: tuple()
end
