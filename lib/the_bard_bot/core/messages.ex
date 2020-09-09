defmodule TheBardBot.Core.Messages do
  @type types :: :unknown | :event
end

defmodule TheBardBot.Core.Messages.Incoming do
  defstruct [:type, value: %{}]

  @type t :: %__MODULE__{
          type: TheBardBot.Core.Messages.types(),
          value: %{}
        }
end

defmodule TheBardBot.Core.Messages.Outgoing do
  defstruct [:type, :channel, :value]

  @type t :: %__MODULE__{
          type: TheBardBot.Core.Messages.types(),
          channel: binary(),
          value: [binary()]
        }
end
