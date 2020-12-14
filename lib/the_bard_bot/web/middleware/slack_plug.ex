defmodule TheBardBot.Web.Middleware.SlackPlug do
  @behaviour Plug

  import Plug.Conn

  @slack Application.get_env(:the_bard_bot, :slack)

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> authenticate()
    |> url_verification()
  end

  defp authenticate(conn) do
    valid = conn.body_params["token"] == @slack[:token]

    unless valid,
      do: conn |> send_resp(400, "Bad Request") |> halt(),
      else: conn
  end

  defp url_verification(conn) do
    case conn.body_params do
      %{"type" => "url_verification"} ->
        conn
        |> send_resp(200, Jason.encode!(conn.body_params))
        |> halt()

      _ ->
        conn
    end
  end
end
