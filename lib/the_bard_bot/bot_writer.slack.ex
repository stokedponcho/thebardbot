defmodule TheBardBot.BotWriter.Slack do
  @behaviour TheBardBot.BotWriter

  require Logger

  alias TheBardBot.Messages
  alias Mint.HTTP1, as: HTTP

  @slack Application.get_env(:the_bard_bot, :slack)

  @impl true
  def write(%Messages.Outgoing{type: :challenge} = message) do
    {:ok, %{challenge: message.value}}
  end

  @impl true
  def write(%Messages.Outgoing{type: :event} = message) do
    case post_message(message.value, message.destination) do
      {:ok} -> {:no_content, nil}
      {:error} -> {:internal_server_error, nil}
    end
  end

  @impl true
  def write(_), do: {:accepted, ""}

  defp post_message(message, channel) do
    path = "/api/chat.postMessage"

    headers = [
      {"Authorization", @slack[:authorization_header]},
      {"content-type", @slack[:content_type]}
    ]

    content =
      Jason.encode!(%{
        text: message,
        channel: channel
      })

    result = post_message(@slack[:host], path, headers, content)

    case result.data.ok do
      true ->
        {:ok}

      false ->
        Logger.error(inspect(result.data))
        {:error}
    end
  end

  defp post_message(host, path, headers, body) do
    Logger.info("Request: POST to #{host}#{path}...")

    {:ok, conn} = HTTP.connect(:https, host, 443)
    {:ok, conn, _} = HTTP.request(conn, "POST", path, headers, body)

    result = handle_responses(conn)
    _ = HTTP.close(conn)

    result
  end

  defp handle_responses(conn) do
    receive do
      message ->
        case HTTP.stream(conn, message) do
          {:ok, conn, responses} ->
            Enum.reduce(responses, %{}, fn resp, state ->
              process_response(conn, resp, state)
            end)

          _ ->
            Logger.error(inspect(message))
            %{conn: conn, data: %{ok: false}}
        end
    end
  end

  defp process_response(conn, {:data, _, value}, state) do
    state = Map.put(state, :data, Jason.decode!(value, keys: :atoms))
    process_response(conn, state)
  end

  defp process_response(conn, {:status, _, value}, state) do
    state = Map.put(state, :status, value)
    process_response(conn, state)
  end

  defp process_response(conn, _, state) do
    process_response(conn, state)
  end

  defp process_response(conn, state), do: Map.put(state, :conn, conn)
end
