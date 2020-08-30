defmodule TheBardBot.BotWriter.SlackTest do
  use ExUnit.Case, async: true

  alias TheBardBot.BotWriter
  alias TheBardBot.Messages.Outgoing

  test "it returns value on challenge" do
    message = %Outgoing{
      type: :challenge,
      value: "value"
    }

    {status, content} = BotWriter.Slack.write(message)

    assert status == :ok
    assert content == %{challenge: "value"}
  end

  test "it returns 202 for unknown type" do
    message = %Outgoing{
      type: :unknown
    }

    {status, _} = BotWriter.Slack.write(message)

    assert status == :accepted
  end
end
