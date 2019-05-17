defmodule SlackInviter.ClearbitApiTest do
  use ExUnit.Case

  alias SlackInviter.ClearbitApi

  describe "ClearbitApi.lookup" do
    test "When the person can be found" do
        email = "newbie@syracuse.io"

        case ClearbitApi.lookup(email) do
          {:ok, %{body: res} } ->
            assert res["name"] == "New Member"
          {:error, err} -> flunk err
        end
    end

    test "When an email is invalid" do
      email = "invalid-email-address!"

      case ClearbitApi.lookup(email) do
        {:ok, %{body: res} } ->
          assert res["error"]["type"] == "invalid_email"
        {:error, err} -> flunk err
      end
    end

    test "When an email is unknown" do
      email = "unknown_person@syracuse.io"

      case ClearbitApi.lookup(email) do
        {:ok, %{body: res} } ->
          assert res["error"]["type"] == "unknown_record"
        {:error, err} -> flunk err
      end
    end
  end
end

