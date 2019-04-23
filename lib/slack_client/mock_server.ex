defmodule SlackClient.MockServer do
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

  post "/users.admin.invite" do
    case conn.params do
      %{"email" =>"newbie@syracuse.io"} ->
        success(conn, %{ok: true})
      %{"email" =>"member@syracuse.io"} ->
        success(conn, %{ok: false, error: "already_in_team"})
      _ ->
        failure(conn)
    end
  end

  post "/users.list" do
    success(conn, %{ok: true, members: [
      %{ real_name: "Alex", presence: "away"},
      %{ real_name: "Bill", presence: "active"},
    ]})
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

  defp failure(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(422, Poison.encode!(%{message: "error message"}))
  end
end
