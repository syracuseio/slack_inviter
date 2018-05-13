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

        results = %{ active: active_user_count(partitioned),
                     away:   Enum.count(partitioned["away"]) }
        {:ok, results}
      %{"ok" => false} ->
        Logger.warn "Fail "<> response["error"]
        {:error, response["error"]}
    end
  end

  defp active_user_count(%{"active" => active}) when is_nil(active), do: 0
  defp active_user_count(%{"active" => active}), do: Enum.count(active)
end
