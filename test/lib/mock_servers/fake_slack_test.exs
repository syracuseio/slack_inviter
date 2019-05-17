defmodule MockServers.FakeSlackTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias MockServers.FakeSlack

  @opts FakeSlack.init([])

  describe "/users.list" do
    test "it returns 200 with a valid payload" do
      conn = conn(:post, "/users.list", %{events: [%{}]})

      conn = FakeSlack.call(conn, @opts)

      assert conn.status == 200
    end
  end

  describe "/users.admin.invite" do
    test "it returns 200 with a valid payload" do
      conn = conn(:post, "/users.admin.invite", %{email: "newbie@syracuse.io"})

      conn = FakeSlack.call(conn, @opts)

      assert conn.status == 200
    end
  end

  describe "/chat.postMessage" do
    test "it returns 200 with a valid payload" do
      conn = conn(:post, "/chat.postMessage")

      conn = FakeSlack.call(conn, @opts)

      assert conn.status == 200
    end
  end

  describe "/ping" do
    test "it returns pong" do
      # Create a test connection
      conn = conn(:get, "/ping")

      # Invoke the plug
      conn = FakeSlack.call(conn, @opts)

      # Assert the response and status
      assert conn.state == :sent
      assert conn.status == 200
      assert conn.resp_body == "pong!"
    end
  end

  test "it returns 404 when no route matches" do
    conn = conn(:get, "/fail")

    conn = FakeSlack.call(conn, @opts)

    assert conn.status == 404
  end
end
