defmodule TheBardBot.Web.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Mox
  alias TheBardBot.Web.Router

  @opts Router.init([])

  setup :verify_on_exit!

  describe "POST requests" do
    test "it returns BotInterpreter response" do
      TheBardBot.Web.BotInterpreter.Mock
      |> expect(:read, fn content -> TheBardBot.Web.BotInterpreter.Slack.read(content) end)

      TheBardBot.Web.BotInterpreter.Mock
      |> expect(:write, fn _ -> {:no_content, nil} end)

      conn = conn(:post, "/", %{})

      conn = Router.call(conn, @opts)

      assert conn.status == 204
      assert conn.resp_body == ""
    end
  end
end
