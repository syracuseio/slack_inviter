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

end

defmodule SlackInviter.Info do
#
# nil => []
# "active" => [
#     %{
#       "color" => "a63024",
#       "deleted" => false,
# "away" => []
#
  def members do
    %{body: response} = SlackInviter.SlackApi.list_users
    case response do
      %{"ok" => true} ->
        partitioned = response
          |> Map.get("members")
          |> Enum.group_by(fn(member) ->
            member["presence"]
          end)

          %{ active: Enum.count(partitioned["active"]),
             away: Enum.count(partitioned["away"]) }
      %{"ok" => false} ->
        IO.puts "Fail "<> response["error"]
    end
  end
end
