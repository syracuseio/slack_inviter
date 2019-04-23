defmodule SlackInviterWeb.PageControllerTest do
  use SlackInviterWeb.ConnCase

  test "GET /", %{conn: conn} do
      conn = get conn, "/"

      assert html_response(conn, 200) =~ "Syracuse Developer Slack"
      assert html_response(conn, 200) =~ "1 members currently online"
      assert html_response(conn, 200) =~ "2 total members"
  end
end
