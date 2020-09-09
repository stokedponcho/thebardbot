defmodule TheBardBot.Core.Event do
  @moduledoc """
    An Event for the Bard to handle.
  """

  @type types :: :app_mention

  defstruct [:type, :text, :authed_users, :users, :channel]

  @type t :: %__MODULE__{
          type: types(),
          text: [any()],
          authed_users: [binary()],
          users: [binary()],
          channel: binary()
        }
end
