defmodule SlackInviter.UsersTest do
  use ExUnit.Case

  alias SlackInviter.Users

  describe "when there are 2 slack users" do
    test "it returns 0 active users" do
      response = %{"ok" => true, "members" => [
            %{ "real_name" => "Aleksandra" },
            %{ "real_name" => "James"},
          ]}
      case Users.parse_list(response) do
        {:ok, res} ->
          assert res == %{active: 2}
        {:error, err} -> flunk err
      end
    end
  end

  #%{method: :post, url: @slack_api_base_url <> "/users.admin.invite", body: "email=member%40syracuse.io&resend=true&token="} ->

  describe "Users.invite when user is not in system" do
    test "sends email to user" do
      email = "newbie@syracuse.io"
      response = %{"ok" => true}
      case Users.parse_invite(email, response) do
        {:ok, res} ->
          assert res == "success"
        {:error, err} -> flunk err
      end
    end
  end

  describe "Users.invite when user is already registered" do
    test "does not invite user" do
      email = "member@syracuse.io"
      response = %{"ok" => false, "error" => "already_in_team"}

      case Users.parse_invite(email, response) do
        {:ok, res} -> flunk res
        {:error, err} ->
          # just test that we pass the error message along i guess
          assert err == "already_in_team"
      end
    end
  end
end



