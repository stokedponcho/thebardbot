defmodule TheBardBot.Web.Serialisation.BotReader.Slack do
  require Logger

  alias TheBardBot.Core.Messages.Incoming

  def read(%{"event" => _} = value),
    do: parse_event(Map.get(value, "authed_users"), Map.get(value, "event"))

  def read(_), do: empty()

  defp parse_event(authed_users, %{"type" => "app_mention"} = event) do
    Logger.info("Handling 'app_mention' event...")

    rich_text_elements =
      event["blocks"]
      |> Enum.flat_map(& &1["elements"])
      |> Enum.filter(&(&1["type"] == "rich_text_section"))
      |> Enum.flat_map(& &1["elements"])

    find_elements = fn type, key, formatter ->
      rich_text_elements
      |> Enum.filter(&(&1["type"] == type))
      |> Enum.map(& &1[key])
      |> Enum.map(&formatter.(&1))
    end

    user_formatter = fn u -> "<@#{u}>" end
    text = find_elements.("text", "text", &String.trim/1)
    users = find_elements.("user", "user_id", &user_formatter.(&1))
    authed_users = authed_users |> Enum.map(&user_formatter.(&1))

    event = %TheBardBot.Core.Event{
      type: event["type"],
      text: text,
      authed_users: authed_users,
      users: users,
      channel: event["channel"]
    }

    %Incoming{type: :event, value: event}
  end

  defp parse_event(_, _), do: empty()

  defp empty(), do: %Incoming{type: :unknown, value: %{}}
end
