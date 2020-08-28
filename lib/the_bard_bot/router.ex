defmodule TheBardBot.Router do
  use Plug.Router

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  require Logger

  alias TheBardBot.Bard

  @bot_user Application.get_env(
              :the_bard_bot,
              :bot_user,
              TheBardBot.BotUser
            )

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  get "/" do
    send_response(conn, 200, Bard.sing())
  end

  get "/:name" do
    send_response(conn, 200, Bard.sing(name))
  end

  post "/" do
    {status, content} = handle(conn.body_params)
    send_response(conn, status, content)
  end

  defp handle(%{"challenge" => value}), do: {:ok, %{challenge: value}}
  defp handle(%{"event" => _} = value), do: handle_event(value["event"])
  defp handle(_), do: {:accepted, nil}

  defp handle_event(%{"type" => "app_mention"} = _) do
    Logger.info("Handling 'app_mention' event...")

    message = Bard.sing()
    channel = "G019P9ULJTU"

    case @bot_user.post_message(message, channel) do
      {:ok} -> {:no_content, nil}
      {:error} -> {:internal_server_error, nil}
    end
  end

  defp handle_event(_), do: {:accepted, nil}

  defp send_response(conn, status, value) do
    value =
      case value do
        nil -> ""
        _ -> Jason.encode!(value)
      end

    conn = conn |> put_resp_content_type("application/json")
    send_resp(conn, status, value)
  end

  match _ do
    send_resp(conn, :not_found, "not found")
  end
end
