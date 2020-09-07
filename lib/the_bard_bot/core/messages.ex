defmodule TheBardBot.Core.Messages.Incoming do
  defstruct [:type, value: %{}]
end

defmodule TheBardBot.Core.Messages.Outgoing do
  defstruct [:type, :channel, :value]
end
