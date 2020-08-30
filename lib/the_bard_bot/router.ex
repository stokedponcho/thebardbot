defmodule TheBardBot.Router do
  use Plug.Router

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  require Logger

  alias TheBardBot.Bard
  alias TheBardBot.Messages

  @bot_reader Application.get_env(
                :the_bard_bot,
                :bot_reader,
                TheBardBot.BotReader
              )
  @bot_user Application.get_env(
              :the_bard_bot,
              :bot_writer,
              TheBardBot.BotWriter
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
    input = @bot_reader.read(conn.body_params)
    output = answer(input)
    {status, content} = @bot_user.write(output)
    send_response(conn, status, content)
  end

  match _ do
    send_resp(conn, :not_found, "not found")
  end

  defp answer(%{type: :event, value: event} = input) do
    message = Bard.sing(hd(event.users))
    channel = event.source
    %Messages.Outgoing{type: input.type, value: message, destination: channel}
  end

  defp answer(input) do
    %Messages.Outgoing{type: input.type, value: input.value}
  end

  defp send_response(conn, status, value) do
    value =
      case value do
        nil -> ""
        _ -> Jason.encode!(value)
      end

    conn = conn |> put_resp_content_type("application/json")
    send_resp(conn, status, value)
  end
end
