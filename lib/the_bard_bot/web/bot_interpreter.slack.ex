defmodule TheBardBot.Web.BotInterpreter.Slack do
  alias TheBardBot.Web.Serialisation

  @impl true
  def read(content), do: Serialisation.BotReader.Slack.read(content)

  @impl true
  def write(message), do: Serialisation.BotWriter.Slack.write(message)

  @impl true
  def write(messages), do: Serialisation.BotWriter.Slack.write(messages)
end
