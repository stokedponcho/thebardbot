defmodule TheBardBot.BotReader.SlackTest do
  use ExUnit.Case

  alias TheBardBot.BotReader.Slack, as: BotReader

  test "it returns " do
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

    result = BotReader.read(content)

    assert result.value.type == "app_mention"
    assert result.value.source == "CHANNELID"
    assert result.value.users == ["<@XXXXXX111>", "<@YYYYYY222>"]
    assert result.value.text == ["some", "text", "more text"]
  end
end
