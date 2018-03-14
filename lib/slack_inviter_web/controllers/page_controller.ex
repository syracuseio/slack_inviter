defmodule SlackInviterWeb.PageController do
  use SlackInviterWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
