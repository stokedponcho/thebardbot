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
    Returns Outgoing messages in reaction to the Incoming one.
  """
  def answer(%{type: :event, value: event} = input) do
    if event.text |> Enum.any?(&(&1 == "serenade")) do
      authed_users = MapSet.new(event.authed_users)

      users =
        event.users
        |> MapSet.new()
        |> MapSet.difference(authed_users)

      users
      |> Enum.map(fn user ->
        %Messages.Outgoing{
          type: input.type,
          value: sing(user),
          channel: event.channel
        }
      end)
    else
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
end
