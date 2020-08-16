defmodule TheBardBotTest do
  use ExUnit.Case
  doctest TheBardBot

  test "sings to a name" do
    assert TheBardBot.sing("Romeo") == "Romeo"
  end
end
