defmodule TheBardBot.Event do
  defstruct [:type, :text, :users, :source]
end

defmodule TheBardBot.Messages.Incoming do
  defstruct [:type, value: %{}]
end

defmodule TheBardBot.Messages.Outgoing do
  defstruct [:type, :destination, :value]
end
