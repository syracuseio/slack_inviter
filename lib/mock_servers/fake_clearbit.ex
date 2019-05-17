defmodule MockServers.FakeClearbit do
  use Plug.Router
  use Plug.Debugger

  require Logger
  plug Plug.Logger, log: :debug

  plug Plug.Parsers,
    parsers: [:json, :urlencoded],
    json_decoder: Poison

  plug :match
  plug :dispatch

  get "/ping" do
    conn
    |> send_resp(200, "pong!")
  end

  get "/people/find" do
    case conn.params do
      %{"email" =>"newbie@syracuse.io"} ->
        success(conn, %{"name" => "New Member"})
      %{"email" =>"unknown_person@syracuse.io"} ->
        unknown(conn)
      %{"email" =>"invalid-email-address!"} ->
        success(conn, %{"error" => %{ "type" => "invalid_email", "message" => "Invalid Email"}})
      _ ->
        failure(conn)
    end
  end

  # A catchall route, 'match' will match no matter the request method,
  # so a response is always returned, even if there is no route to match.
  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, "oops... Nothing here :(")
  end

  defp success(conn, body) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(body))
  end

  defp unknown(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(202, Poison.encode!(%{"error" => %{"message" =>
      "Unknown person.", "type" => "unknown_record"}}))
  end

  defp failure(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(422, Poison.encode!(%{message: "error message"}))
  end
end

