defmodule SlackInviter.SlackApi do
  use Tesla

  @slack_api_base_url Application.get_env(:slack_inviter, :slack_api_base_url)
  @slack_api_token Application.get_env(:slack_inviter, :slack_api_token)
  @slack_notify_channel Application.get_env(:slack_inviter, :slack_notify_channel)

  plug Tesla.Middleware.BaseUrl, @slack_api_base_url
  plug Tesla.Middleware.FormUrlencoded
  plug Tesla.Middleware.DecodeJson

  def list_users do
    post("/users.list", %{presence: 1, token: @slack_api_token})
  end

  def invite_user(email) do
    post("/users.admin.invite", %{email: email, resend: true, token: @slack_api_token})
  end

  def notify_invited(message, blocks \\ "[]") do
    post("/chat.postMessage", %{channel: @slack_notify_channel,
      text: message,
      as_user: false,
      username: "InviteBot",
      icon_emoji: ":chart_with_upwards_trend:",
      blocks: blocks,
      token: @slack_api_token})
  end
end

