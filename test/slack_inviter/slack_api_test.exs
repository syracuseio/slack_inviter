defmodule SlackInviter.SlackApiTest do
  use ExUnit.Case

  alias SlackInviter.SlackApi

  describe "SlackApi.list_users" do
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


