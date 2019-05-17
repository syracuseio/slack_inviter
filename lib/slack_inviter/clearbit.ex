defmodule SlackInviter.Clearbit do
  alias SlackInviter.ClearbitApi
  require Logger

  defstruct [:name, :bio, :avatar, :title, :email, :employer, :twitter_handle, :twitter_followers, :location]

  def lookup(email) do
    struct = email
      |> get_person_data
      |> build_person
  end

  defp get_person_data(email) do
    {:ok, %{body: response}} = ClearbitApi.lookup(email)
    parse_clearbit_lookup(email, response)
  end
  defp parse_clearbit_lookup(email, %{"error" => %{"type" => "queued"}}) do
    Logger.error "Unknown email, retrying in 5sec... " <> email
    # nstart a new task to notify slack in 5s
  end
  defp parse_clearbit_lookup(email, %{"error" => %{"message" => message}}) do
    Logger.error "Unable to lookup " <> email <> " : " <> message
  end
  defp parse_clearbit_lookup(email, response), do: response

  defp build_person({:error, %{code: :queued}}) do
    # want it to retry this whole thing if queued
    Logger.info "Lookup queued, retrying"
  end

  defp build_person({:error, _}) do
    Logger.info "No clearbit data found"
  end

  defp build_person(%{"avatar" => avatar, "bio" => bio, "email" => email, "employment" => employment, "location" => location, "name" => name, "twitter" => twitter }) do
    %SlackInviter.Clearbit{
      avatar: avatar,
      bio: bio,
      email: email,
      location: location,
      name: name["fullName"] ,
      title: employment["title"],
      employer: employment["name"],
      twitter_handle: twitter["handle"],
      twitter_followers: twitter["followers"],
    }
  end

end
