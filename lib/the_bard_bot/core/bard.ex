defmodule TheBardBot.Core.Bard do
  @moduledoc """
    Domain module for the Bard compositions.
  """

  require Logger
  require Integer

  alias TheBardBot.Core.Messages

  @words_file Application.fetch_env!(:the_bard_bot, :words)

  @doc """
  Generates a Shakespearian insult by choosing 3 words from 3 lists of words,
  with a placeholder for a name.

  ## Examples

      iex> :rand.seed(:exsplus, {220, 30, 40})
      iex> TheBardBot.Core.Bard.sing()
      "{0}! Thou gorbellied clapper-clawed miscreant!"
  """
  @spec sing() :: String.t()
  def sing() do
    sing("{0}")
  end

  @doc """
  Generates a Shakespearian insult by choosing 3 words from 3 lists of words,
  with a name.

  ## Examples

      iex> :rand.seed(:exsplus, {20, 130, 140})
      iex> TheBardBot.Core.Bard.sing("Romeo")
      "Thou pribbling tardy-gaited scut, Romeo!"
  """
  @spec sing(name :: String.t()) :: String.t()
  def sing(to_name) do
    file_content = File.read!(@words_file)
    columns = parse_columns(file_content)

    Logger.debug("Imported #{Enum.count(columns)} columns from #{@words_file}.")

    composition = compose(columns)

    case Integer.is_odd(:rand.uniform(100)) do
      true -> "#{to_name}! Thou #{composition}!"
      false -> "Thou #{composition}, #{to_name}!"
    end
  end

  @doc """
    Returns Outgoing messages in answer to the Incoming one.
  """
  @spec answer(input :: Messages.Incoming.t()) :: list(Messages.Outgoing.t())
  def answer(%{type: :event, value: event} = input) do
    create_message = fn value ->
      %Messages.Outgoing{
        type: input.type,
        value: value,
        channel: event.channel
      }
    end

    cond do
      # check if target is itself
      trick?(event) ->
        [create_message.("Nice try. Connard.")]

      serenade_asked?(event) ->
        serenade(event, create_message)

      true ->
        []
    end
  end

  def answer(_), do: []

  defp parse_columns(content) do
    content
    |> String.split(["\r\n", "\n"], trim: true)
    |> Enum.map(&String.split(&1, ","))
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  defp compose(columns) do
    columns
    |> Enum.reduce([], fn column, acc ->
      acc ++ Enum.take_random(column, 1)
    end)
    |> Enum.join(" ")
  end

  defp trick?(event) do
    event.users
    |> Enum.filter(&(&1 in event.authed_users))
    |> Enum.count() > 1
  end

  defp serenade_asked?(event), do: event.text |> Enum.any?(&(&1 == "serenade"))

  defp serenade(event, create_message) do
    authed_users = MapSet.new(event.authed_users)

    users =
      event.users
      |> MapSet.new()
      |> MapSet.difference(authed_users)

    users
    |> Enum.map(fn user ->
      create_message.(sing(user))
    end)
  end
end
