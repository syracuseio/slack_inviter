defmodule SlackInviter.SlackApi do
  use Tesla

  @slack_api_base_url System.get_env("SLACK_API_BASE")
  @slack_api_token System.get_env("SLACK_API_TOKEN")

  plug Tesla.Middleware.BaseUrl, @slack_api_base_url
  plug Tesla.Middleware.FormUrlencoded
  plug Tesla.Middleware.DecodeJson

  def list_users do
    post("/users.list", %{presence: 1, token: @slack_api_token})
  end

  def invite_user(email) do
    post("/users.admin.invite", %{email: email, resend: true, token: @slack_api_token})
  end
end

