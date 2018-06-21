defmodule SlackInviter.SlackApiTest do
  use ExUnit.Case
  import Tesla.Mock

  alias SlackInviter.SlackApi

  @slack_api_base_url Application.get_env(:slack_inviter, :slack_api_base_url)

  describe "SlackApi.list_users" do
    setup do
      Tesla.Mock.mock fn
        %{method: :post, url: @slack_api_base_url <> "/users.list"} ->
          {201, %{}, %{"ok" => true, "members" => [
                                        %{ "real_name" => "Aleksandra", "presence" => "away"},
                                        %{ "real_name" => "Aleksandra", "presence" => "active"},
                                      ]}}
      end

      :ok
    end

    test "returns a list of slack members" do
      case SlackApi.list_users do
        {:ok, %{body: res} } ->
          assert res["ok"] == true
          assert Enum.count(res["members"]) == 2
        {:error, err} -> flunk err
      end
    end
  end


  describe "SlackApi.invite_user" do
    setup do
      Tesla.Mock.mock fn
        %{method: :post, url: @slack_api_base_url <> "/users.admin.invite", body: "email=newbie%40syracuse.io&resend=true&token="} ->
          {200, %{}, %{"ok" => true}}
        %{method: :post, url: @slack_api_base_url <> "/users.admin.invite", body: "email=member%40syracuse.io&resend=true&token="} ->
          {200, %{}, %{"ok" => false, "error" => "already_in_team"}}
      end

      :ok
    end

    test "When a user is new, invite them to slack" do
        email = "newbie@syracuse.io"

        case SlackApi.invite_user(email) do
          {:ok, %{body: res} } ->
            assert res["ok"] == true
          {:error, err} -> flunk err
        end
    end

    test "When a user is already in chat, fail with error" do
        email = "member@syracuse.io"


        case SlackApi.invite_user(email) do
          {:ok, %{body: res} } ->
            assert res["ok"] == false
            assert res["error"] == "already_in_team"
          {:error, err} -> flunk err
      end
    end
  end
end


