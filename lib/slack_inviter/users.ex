defmodule SlackInviter.Users do
  require Logger
  alias SlackInviter.SlackApi

  def invite(email) do
    {:ok, %{body: response}} = SlackApi.invite_user(email)
    parse_invite email, response
  end

  def parse_invite(email, response) do
    case response do
      %{"ok" => true} ->
        notify_slack(email)
        {:ok, "success"}
      %{"ok" => false} ->
        Logger.info "Fail " <> email <> " : " <> response["error"]
        {:error, response["error"]}
    end
  end

  def list do
    {:ok, %{body: response}} = SlackApi.list_users
    parse_list response
  end

  # nil => []
  # "active" => [
  #     %{
  #       "color" => "a63024",
  #       "deleted" => false,
  # "away" => []
  def parse_list(response) do
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
        Logger.info "Fail "<> response["error"]
        {:error, response["error"]}
    end
  end

  def notify_slack(email) do
    {:ok, %{body: response}} = SlackApi.notify_invited(email)
    parse_notify_slack email, response
  end

  def parse_notify_slack(email, response) do
    case response do
      %{"ok" => true} ->
        {:ok, "success"}
      %{"ok" => false} ->
        Logger.info "Could not send notification to slack: " <> email <> " : " <> response["error"]
        {:error, response["error"]}
    end
  end

  defp active_user_count(%{"active" => active}), do: Enum.count(active)
  defp active_user_count(_), do: 0
end
