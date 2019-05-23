defmodule SlackInviter.ClearbitApi do
  use Tesla

  @clearbit_api_key Application.get_env(:slack_inviter, :clearbit_api_key)
  @clearbit_api_base_url Application.get_env(:slack_inviter, :clearbit_api_base_url)

  plug Tesla.Middleware.BaseUrl, @clearbit_api_base_url
  plug Tesla.Middleware.BasicAuth, username: @clearbit_api_key

  plug Tesla.Middleware.JSON

  def lookup(email) do
    get "people/find?email=" <> email
  end
end


