defmodule MockServers.FakeClearbitTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias MockServers.FakeClearbit

  @opts FakeClearbit.init([])
  describe "people/find" do
    test "it returns 200 when person data found" do
      # Create a test connection
      conn = conn(:get, "/people/find?email=newbie@syracuse.io")

      # Invoke the plug
      conn = FakeClearbit.call(conn, @opts)

      # Assert the response
      assert conn.status == 200
    end

    test "it returns 200 when person is unknown" do
      # Create a test connection
      conn = conn(:get, "/people/find?email=unknown_person@syracuse.io")

      # Invoke the plug
      conn = FakeClearbit.call(conn, @opts)

      # Assert the response
      assert conn.status == 202
    end

  end

  describe "/ping" do
    test "it returns pong" do
      # Create a test connection
      conn = conn(:get, "/ping")

      # Invoke the plug
      conn = FakeClearbit.call(conn, @opts)

      # Assert the response and status
      assert conn.state == :sent
      assert conn.status == 200
      assert conn.resp_body == "pong!"
    end
  end

  test "it returns 404 when no route matches" do
    # Create a test connection
    conn = conn(:get, "/fail")

    # Invoke the plug
    conn = FakeClearbit.call(conn, @opts)

    # Assert the response
    assert conn.status == 404
  end
end

