defmodule TheBardBotTest do
  use ExUnit.Case
  doctest TheBardBot

  test "sings to a name" do
    expected = ~r/Thou [\p{L}-]+ [\p{L}-]+ [\p{L}-]+, Romeo!/u
    result = TheBardBot.sing("Romeo")
    IO.puts(result)

    assert String.match?(result, expected)
  end
end
