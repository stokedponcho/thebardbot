defmodule TheBardBot do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: TheBardBot.Worker.start_link(arg)
      # {TheBardBot.Worker, arg}
      {Plug.Cowboy, scheme: :http, plug: TheBardBot.Web.Router, port: port()},
      {TheBardBot.Jobs.QuoteOfTheDay, []},
      {TheBardBot.Jobs.UselessFactOfTheDay, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TheBardBot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp port, do: Application.get_env(:cowboy, :port, 4000)
end
