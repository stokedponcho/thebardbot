defmodule TheBardBot.Web.BotInterpreter.SlackTest do
  use ExUnit.Case

  alias TheBardBot.Core.Messages
  alias TheBardBot.Web.BotInterpreter.Slack, as: BotInterpreter

  describe "read" do
    test "it parses JSON from Slack" do
      content = %{
        "authed_users" => [
          "BOTUSERID"
        ],
        "event" => %{
          "type" => "app_mention",
          "channel" => "CHANNELID",
          "user" => "BOTUSERID",
          "blocks" => [
            %{
              "elements" => [
                %{
                  "elements" => [
                    %{
                      "type" => "user",
                      "user_id" => "BOTUSERID"
                    },
                    %{
                      "text" => " some ",
                      "type" => "text"
                    },
                    %{
                      "text" => " text ",
                      "type" => "text"
                    },
                    %{
                      "type" => "user",
                      "user_id" => "YYYYYY222"
                    },
                    %{
                      "type" => "user",
                      "user_id" => "XXXXXX111"
                    },
                    %{
                      "text" => " more text ",
                      "type" => "text"
                    }
                  ],
                  "type" => "rich_text_section"
                }
              ],
              "type" => "rich_text"
            }
          ]
        }
      }

      result = BotInterpreter.read(content)
      value = result.value

      assert value.type == "app_mention"
      assert value.channel == "CHANNELID"
      assert value.authed_users == ["<@BOTUSERID>"]
      assert value.users == ["<@BOTUSERID>", "<@YYYYYY222>", "<@XXXXXX111>"]
      assert value.text == ["some", "text", "more text"]
    end
  end

  describe "write" do
    test "returns value on challenge" do
      message = %Messages.Outgoing{
        type: :challenge,
        value: "value"
      }

      {status, content} = BotInterpreter.write(message)

      assert status == :ok
      assert content == %{challenge: "value"}
    end

    test "returns 202 for unknown type" do
      message = %Messages.Outgoing{
        type: :unknown
      }

      {status, _} = BotInterpreter.write(message)

      assert status == :accepted
    end

    test "return accepted for message list" do
      messages = [
        %Messages.Outgoing{type: :unknown},
        %Messages.Outgoing{type: :unknown}
      ]

      {status, _} = BotInterpreter.write(messages)

      assert status == :accepted
    end
  end
end
