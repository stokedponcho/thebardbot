defmodule TheBardBot.BardTest do
  use ExUnit.Case
  alias TheBardBot.Bard
  doctest Bard

  test "sings to a name" do
    expected = ~r/Thou [\p{L}-]+ [\p{L}-]+ [\p{L}-]+, Romeo!/u
    result = Bard.sing("Romeo")

    assert String.match?(result, expected)
  end
end
