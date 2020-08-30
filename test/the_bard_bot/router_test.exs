defmodule TheBardBot.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Mox
  alias TheBardBot.Router

  @opts Router.init([])

  setup :verify_on_exit!

  describe "POST requests" do
    test "it returns BotWriter response" do
      TheBardBot.BotWriter.Mock
      |> expect(:write, fn _ -> {:no_content, nil} end)

      conn = conn(:post, "/", %{})

      conn = Router.call(conn, @opts)

      assert conn.status == 204
      assert conn.resp_body == ""
    end
  end
end
