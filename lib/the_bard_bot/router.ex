defmodule TheBardBot.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(:dispatch)

  get "/:name" do
    send_resp(conn, 200, TheBardBot.sing(name))
  end

  match _ do
    send_resp(conn, 404, "not found")
  end
end
