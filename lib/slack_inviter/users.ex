defmodule SlackInviter.Users do
  require Logger

  def invite(email) do
    %{body: response} = SlackInviter.SlackApi.invite_user(email)

    case response do
      %{"ok" => true} ->
        {:ok, "success"}
      %{"ok" => false} ->
        Logger.warn "Fail "<> response["error"]
        {:error, response["error"]}
    end
  end

  # nil => []
  # "active" => [
  #     %{
  #       "color" => "a63024",
  #       "deleted" => false,
  # "away" => []
  def list do
    %{body: response} = SlackInviter.SlackApi.list_users

    case response do
      %{"ok" => true} ->
        partitioned = response
                      |> Map.get("members")
                      |> Enum.group_by(fn(member) ->
                        member["presence"]
                      end)

        if is_nil(partitioned) do
          Logger.debug(inspect(response)) #seeing 500s in the logs, not sure what's going on
        end
        results = %{ active: Enum.count(partitioned["active"]),
             away: Enum.count(partitioned["away"]) }
        {:ok, results}
      %{"ok" => false} ->
        Logger.warn "Fail "<> response["error"]
        {:error, response["error"]}
    end
  end
end
