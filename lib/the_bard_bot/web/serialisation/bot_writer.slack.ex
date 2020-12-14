defmodule TheBardBot.Web.Serialisation.BotWriter.Slack do
  require Logger

  alias TheBardBot.Core.Messages
  alias Mint.HTTP1, as: HTTP

  @slack Application.get_env(:the_bard_bot, :slack)

  def write([_ | _] = messages) do
    write_multiple(messages, nil)
  end

  def write(%Messages.Outgoing{type: :url_verification} = message) do
    {:ok, %{challenge: message.value}}
  end

  def write(message) do
    post_message(message.value, message.channel)
    {:no_content, nil}
  end

  defp write_multiple([], response), do: response

  defp write_multiple([head | tail], _) do
    response = write(head)
    write_multiple(tail, response)
  end

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

    if result.data.ok == false do
      Logger.error(inspect(result))
      raise result.data.error
    end
  end

  defp post_message(host, path, headers, body) do
    Logger.info("Request: POST to #{host}#{path}...")
    Logger.info(inspect(headers))
    Logger.info(inspect(body))

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
    Logger.debug(inspect(value))
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
