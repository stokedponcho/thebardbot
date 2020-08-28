defmodule TheBardBot.BotUser do
  @callback post_message(message :: String.t(), channel :: String.t()) :: {:ok} | {:error}
end
