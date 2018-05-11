defmodule SlackInviterWeb.InviteController do
  use SlackInviterWeb, :controller
  require Logger

  def index(conn, _params) do
    redirect conn, external: "https://syracuseio.slack.com"
  end

  def create(conn, %{"register" => %{"email" => email}}) do
    case SlackInviter.Users.invite(email) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Invitation sent to #{email}.")
        |> redirect(to: page_path(conn, :index))
      {:error, "already_in_team"} ->
        conn
        |> put_flash(
             :info,
             "This email already has an account. Please sign in by clicking the link below."
           )
        |> redirect(to: page_path(conn, :index))
      {:error, "invalid_email"} ->
        conn
        |> put_flash(
             :error,
             "Could not send invitation to invalid email: #{email}."
           )
        |> redirect(to: page_path(conn, :index))
      {:error, reason} ->
        Logger.error fn ->
          "Slack invite failure: #{reason}."
        end
        conn
        |> put_flash(
             :error,
             "Could not invite #{email}. Please, try again later."
           )
        |> redirect(to: page_path(conn, :index))
    end
  end
end
