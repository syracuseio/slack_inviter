defmodule SlackInviterWeb.PageController do
  use SlackInviterWeb, :controller
  require Logger

  def index(conn, _params) do
    case SlackInviter.Users.list do
      {:ok, user_counts} ->
        render conn, "index.html", members: user_counts
      {:error, reason} ->
        Logger.warn "Slack member retrieval failure: #{reason}."
    end

    render conn, "index.html", members: %{}
  end
end
