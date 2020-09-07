defmodule TheBardBot.Core.BardTest do
  use ExUnit.Case

  alias TheBardBot.Core.Bard
  alias TheBardBot.Core.Event
  alias TheBardBot.Core.Messages

  doctest Bard

  describe "sings" do
    test "to a name" do
      :rand.seed(:exsplus, {20, 130, 140})
      expected = ~r/Thou [\p{L}-]+ [\p{L}-]+ [\p{L}-]+, Romeo!/u
      result = Bard.sing("Romeo")

      assert String.match?(result, expected)
    end

    test "to a name 2" do
      :rand.seed(:exsplus, {220, 30, 40})
      expected = ~r/Romeo! Thou [\p{L}-]+ [\p{L}-]+ [\p{L}-]+!/u
      result = Bard.sing("Romeo")

      assert String.match?(result, expected)
    end
  end

  describe "answers to serenade" do
    setup do
      {:ok,
       message: %Messages.Incoming{
         type: :event,
         value: %Event{
           type: "app_mention",
           text: ["serenade"],
           authed_users: ["<@BOTUSERID>"],
           users: ["<@BOTUSERID>", "<@OTHERUSERID>"],
           channel: "CHANNELID"
         }
       }}
    end

    test "with only one message, excluding bot user", context do
      result = Bard.answer(context[:message])

      assert length(result) == 1
    end

    test "with same channel", context do
      result = Bard.answer(context[:message])
      result = hd(result)

      assert result.channel == "CHANNELID"
    end
  end

  test "answer ignores unknown commands" do
    message = %Messages.Incoming{
      type: :unknown
    }

    assert Bard.answer(message) == []
  end
end
