defmodule TheBardBot do
  @moduledoc """
  Documentation for TheBardBot.
  """

  @words_file "assets/words"

  @doc """
  Generates a Shakespearian insult by choosing 3 words from 3 lists of words,
  with a placeholder for a name.

  ## Examples

      iex> :rand.seed(:exsplus, {20, 30, 40})
      iex> TheBardBot.sing()
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
      iex> TheBardBot.sing("Romeo")
      "Thou beslubbering pox-marked minnow, Romeo!"
  """
  @spec sing(name :: String.t()) :: String.t()
  def sing(to_name) do
    file_content = File.read!(@words_file)

    columns =
      file_content
      |> String.split(["\r\n", "\n"], trim: true)
      |> Enum.map(&String.split(&1, ","))
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)

    composition =
      columns
      |> Enum.reduce([], fn column, acc ->
        acc ++ Enum.take_random(column, 1)
      end)

    "Thou #{Enum.join(composition, " ")}, #{to_name}!"
  end
end
