defmodule TheBardBot.Web.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Mox
  alias TheBardBot.Web.Router

  @opts Router.init([])

  setup :verify_on_exit!

  describe "POST requests" do
    test "returns BotInterpreter response" do
      TheBardBot.Web.BotInterpreter.Mock
      |> expect(:read, &TheBardBot.Web.BotInterpreter.Slack.read/1)

      TheBardBot.Web.BotInterpreter.Mock
      |> expect(:write, fn _ -> {:no_content, nil} end)

      conn =
        conn(:post, "/", %{
          token: "token"
        })

      conn = Router.call(conn, @opts)

      assert conn.status == 204
      assert conn.resp_body == ""
    end
  end

  test "it returns challenge" do
    conn =
      conn(:post, "/", %{
        type: "url_verification",
        challenge: "hello",
        token: "token"
      })

    conn = Router.call(conn, @opts)

    assert conn.status == 200
    assert conn.resp_body == Jason.encode!(conn.body_params)
  end
end
