defmodule TheBardBot.BotReader.Slack do
  @behaviour TheBardBot.BotReader

  require Logger

  alias TheBardBot.Messages.Incoming

  @impl true
  def read(%{"challenge" => value}), do: parsed(:challenge, value)

  @impl true
  def read(%{"event" => _} = value),
    do: parse_event(Map.get(value, "authed_users"), Map.get(value, "event"))

  @impl true
  def read(_), do: empty()

  defp parse_event(authed_users, %{"type" => "app_mention"} = event) do
    Logger.info("Handling 'app_mention' event...")

    rich_text_elements =
      event["blocks"]
      |> Enum.flat_map(& &1["elements"])
      |> Enum.filter(&(&1["type"] == "rich_text_section"))
      |> Enum.flat_map(& &1["elements"])

    find_elements = fn type, key ->
      rich_text_elements
      |> Enum.filter(&(&1["type"] == type))
      |> Enum.map(& &1[key])
    end

    text =
      find_elements.("text", "text")
      |> Enum.map(&String.trim/1)

    users =
      find_elements.("user", "user_id")
      |> MapSet.new()
      |> MapSet.difference(MapSet.new(authed_users))
      |> Enum.map(&"<@#{&1}>")

    event = %TheBardBot.Event{
      type: event["type"],
      text: text,
      users: users,
      source: event["channel"]
    }

    parsed(:event, event)
  end

  defp parse_event(_, _), do: empty()

  defp parsed(type, value), do: %Incoming{type: type, value: value}
  defp empty(), do: %Incoming{type: :unknown, value: %{}}
end
