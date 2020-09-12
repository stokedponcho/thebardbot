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

  describe "answer to serenade" do
    setup do
      {:ok,
       message: %Messages.Incoming{
         type: :event,
         value: %Event{
           type: "app_mention",
           text: ["serenade"],
           authed_users: ["<@BOTUSERID>"],
           users: ["<@BOTUSERID>", "<@OTHERUSERID>", "<@OTHERUSERID>", "<@ANOTHERUSERID>"],
           channel: "CHANNELID"
         }
       }}
    end

    test "returns only two messages, excluding bot user", context do
      result = Bard.answer(context[:message])

      assert length(result) == 2
    end

    test "returns same channel", context do
      result = Bard.answer(context[:message])
      result = hd(result)

      assert result.channel == "CHANNELID"
    end
  end

  describe "anwser detects attempt to unleash thebardbot on thebardbot" do
    setup do
      {:ok,
       message: %Messages.Incoming{
         type: :event,
         value: %Event{
           type: "app_mention",
           authed_users: ["<@BOTUSERID>"],
           text: [],
           users: ["<@BOTUSERID>", "<@BOTUSERID>", "<@OTHERUSERID>"],
           channel: "CHANNELID"
         }
       }}
    end

    test "returns one message", context do
      result = Bard.answer(context[:message])

      assert length(result) == 1
    end

    test "returns diss", context do
      result = Bard.answer(context[:message])
      result = hd(result)

      assert result.value == "Nice try. Connard."
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
