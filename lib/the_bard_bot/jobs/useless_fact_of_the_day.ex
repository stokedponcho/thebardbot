defmodule TheBardBot.Jobs.UselessFactOfTheDay do
  use GenServer
  require Logger
  alias Mint.HTTP1, as: HTTP

  @bot_interpreter Application.get_env(
                     :the_bard_bot,
                     :bot_interpreter,
                     TheBardBot.Web.BotInterpreter
                   )
  @settings Application.fetch_env!(:the_bard_bot, :useless_fact_of_the_day)

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    if @settings[:enabled] do
      if @settings[:run_on_init], do: do_work()
      schedule_next()
    end

    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do
    do_work()
    schedule_next()
    {:noreply, state}
  end

  defp do_work() do
    message = %TheBardBot.Core.Messages.Outgoing{
      type: :unknown,
      channel: @settings[:channel],
      value: "Useless fact of the day!\n>#{get_fact()}"
    }

    @bot_interpreter.write(message)
  end

  defp get_fact() do
    action = "GET"
    host = "useless-facts.sameerkumar.website"
    path = "/api"

    Logger.info("Request: #{action} to #{host}#{path}...")

    {:ok, conn} = HTTP.connect(:https, host, 443)
    {:ok, conn, _} = HTTP.request(conn, action, path, [], nil)
    result = handle_responses(conn).data.data
    _ = HTTP.close(conn)

    result
  end

  defp schedule_next() do
    wait = Time.diff(@settings[:start], Time.utc_now(), :millisecond)

    wait =
      cond do
        wait <= 0 ->
          {_, start} = DateTime.new(Date.add(Date.utc_today(), 1), @settings[:start])
          DateTime.diff(start, DateTime.utc_now(), :millisecond)

        wait > 0 ->
          wait
      end

    Logger.info(
      "Next will be posted to #{@settings[:channel]}, on #{
        DateTime.add(DateTime.utc_now(), wait, :millisecond)
      }."
    )

    Process.send_after(self(), :work, wait)
  end

  defp handle_responses(conn) do
    receive do
      message ->
        case HTTP.stream(conn, message) do
          {:ok, conn, responses} ->
            Enum.reduce(responses, %{}, fn resp, state ->
              process_response(conn, resp, state)
            end)

          _ ->
            Logger.error(inspect(message))
            %{conn: conn, data: %{ok: false}}
        end
    end
  end

  defp process_response(conn, {:data, _, value}, state) do
    Logger.debug(inspect(value))
    state = Map.put(state, :data, Jason.decode!(value, keys: :atoms))
    process_response(conn, state)
  end

  defp process_response(conn, {:status, _, value}, state) do
    state = Map.put(state, :status, value)
    process_response(conn, state)
  end

  defp process_response(conn, _, state) do
    process_response(conn, state)
  end

  defp process_response(conn, state), do: Map.put(state, :conn, conn)
end
