defmodule TheBardBot.Web.Router do
  use Plug.Router

  require Logger

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(TheBardBot.Web.Middleware.SlackPlug)
  plug(:dispatch)

  @bot_interpreter Application.get_env(
                     :the_bard_bot,
                     :bot_interpreter,
                     TheBardBot.Web.BotInterpreter
                   )
  alias TheBardBot.Core.Bard

  get "/" do
    send_response(conn, 200, Bard.sing())
  end

  get "/:name" do
    send_response(conn, 200, Bard.sing(name))
  end

  post "/" do
    input = @bot_interpreter.read(conn.body_params)
    output = Bard.answer(input)
    {status, content} = @bot_interpreter.write(output)
    send_response(conn, status, content)
  end

  match _ do
    send_resp(conn, :not_found, "Not Found")
  end

  defp send_response(conn, status, value) do
    body =
      case value do
        nil -> ""
        _ -> Jason.encode!(value)
      end

    conn = conn |> put_resp_content_type("application/json")
    send_resp(conn, status, body)
  end
end
