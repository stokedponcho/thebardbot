defmodule TheBardBot.Web.BotInterpreter.Slack do
  @behaviour TheBardBot.Web.BotInterpreter

  alias TheBardBot.Web.Serialisation.BotReader
  alias TheBardBot.Web.Serialisation.BotWriter

  @impl true
  def read(content), do: BotReader.Slack.read(content)

  @impl true
  def write([messages]), do: BotWriter.Slack.write(messages)

  @impl true
  def write(message), do: BotWriter.Slack.write(message)
end
