defmodule SlackInviterWeb.PageControllerTest do
  use SlackInviterWeb.ConnCase
  import Tesla.Mock

  @slack_api_base_url Application.get_env(:slack_inviter, :slack_api_base_url)

  setup do
    Tesla.Mock.mock fn
      %{method: :post, url: @slack_api_base_url <> "/users.list"} ->
        {201, %{}, %{"ok" => true, "members" => [
          %{ "real_name" => "Aleksandra", "presence" => "away"},
          %{ "real_name" => "Aleksandra", "presence" => "active"},
        ]}}
    end

    :ok
  end

  test "GET /", %{conn: conn} do
      conn = get conn, "/"

      assert html_response(conn, 200) =~ "Syracuse Developer Slack"
      assert html_response(conn, 200) =~ "1 members currently online"
      assert html_response(conn, 200) =~ "2 total members"
  end
end
