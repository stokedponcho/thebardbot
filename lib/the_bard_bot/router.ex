defmodule TheBardBot.Router do
  use Plug.Router

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  require Logger
  require Poison

  alias TheBardBot.Bard

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(:dispatch)

  get "/" do
    get_response(conn, fn -> Bard.sing() end)
    # send_resp(conn, 200, TheBardBot.sing())
  end

  get "/:name" do
    get_response(conn, fn -> Bard.sing(name) end)
    # send_resp(conn, 200, TheBardBot.sing(name))
  end

  defp get_response(conn, action) do
    value = %{
      value: action.()
    }

    response = Poison.encode!(value)
    send_resp(conn |> put_resp_content_type("application/json"), 200, response)
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
