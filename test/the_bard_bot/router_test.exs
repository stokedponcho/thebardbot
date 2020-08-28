defmodule TheBardBot.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Mox
  alias TheBardBot.Router

  @opts Router.init([])

  setup :verify_on_exit!

  test "it returns value on challenge" do
    params = Jason.decode!("{\"challenge\":\"value\"}")
    conn = conn(:post, "/", params)

    conn = Router.call(conn, @opts)

    assert conn.status == 200
    assert conn.resp_body == "{\"challenge\":\"value\"}"
  end

  test "it returns 204 for app_mention event" do
    TheBardBot.BotUser.Mock
    |> expect(:post_message, fn _, _ -> {:ok} end)

    params = Jason.decode!("{\"event\": {\"type\": \"app_mention\"}}")
    conn = conn(:post, "/", params)

    conn = Router.call(conn, @opts)

    assert conn.status == 204
  end

  test "it returns 500 for BotUser error" do
    TheBardBot.BotUser.Mock
    |> expect(:post_message, fn _, _ -> {:error} end)

    params = Jason.decode!("{\"event\": {\"type\": \"app_mention\"}}")
    conn = conn(:post, "/", params)

    conn = Router.call(conn, @opts)

    assert conn.status == 500
  end

  test "it returns 202 for unhandled events" do
    params = Jason.decode!("{\"event\": {\"type\": \"unhandled\"}}")
    conn = conn(:post, "/", params)

    conn = Router.call(conn, @opts)

    assert conn.status == 202
  end

  test "it returns 202 unhandled requests" do
    conn = conn(:post, "/", %{})

    conn = Router.call(conn, @opts)

    assert conn.status == 202
  end
end
