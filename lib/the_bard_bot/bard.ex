defmodule TheBardBot.Bard do
  @moduledoc """
  Documentation for TheBardBot.
  """

  require Logger

  @words_file Application.fetch_env!(:the_bard_bot, :words)

  @doc """
  Generates a Shakespearian insult by choosing 3 words from 3 lists of words,
  with a placeholder for a name.

  ## Examples

      iex> :rand.seed(:exsplus, {20, 30, 40})
      iex> TheBardBot.Bard.sing()
      "Thou beslubbering pox-marked minnow, {0}!"
  """
  @spec sing() :: String.t()
  def sing() do
    sing("{0}")
  end

  @doc """
  Generates a Shakespearian insult by choosing 3 words from 3 lists of words,
  with a name.

  ## Examples

      iex> :rand.seed(:exsplus, {20, 30, 40})
      iex> TheBardBot.Bard.sing("Romeo")
      "Thou beslubbering pox-marked minnow, Romeo!"
  """
  @spec sing(name :: String.t()) :: String.t()
  def sing(to_name) do
    file_content = File.read!(@words_file)
    columns = parse_columns(file_content)

    Logger.debug("Imported #{Enum.count(columns)} columns from #{@words_file}.")

    composition = compose(columns)

    "Thou #{composition}, #{to_name}!"
  end

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
