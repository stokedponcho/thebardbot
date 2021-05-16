defmodule TheBardBot.Jobs.QuoteOfTheDay do
  use GenServer
  require Logger

  @bot_interpreter Application.get_env(
                     :the_bard_bot,
                     :bot_interpreter,
                     TheBardBot.Web.BotInterpreter
                   )
  @settings Application.fetch_env!(:the_bard_bot, :quote_of_the_day)

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
    {qt, author} = get_quote()

    message = %TheBardBot.Core.Messages.Outgoing{
      type: :unknown,
      channel: @settings[:channel],
      value: "Quote of the day!\n>_#{qt}_\n>- #{author}"
    }

    @bot_interpreter.write(message)
  end

  defp get_quote() do
    {:ok, pid} =
      :python.start([
        {:python, 'python3'},
        {:python_path, './assets'}
      ])

    qt = :python.call(pid, :quotes, :get, [])
    :python.stop(pid)

    qt
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
      "Next quote will be posted to #{@settings[:channel]}, on #{
        DateTime.add(DateTime.utc_now(), wait, :millisecond)
      }."
    )

    Process.send_after(self(), :work, wait)
  end
end
