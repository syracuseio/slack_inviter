defmodule SlackInviter.Notifier do
  alias SlackInviter.Clearbit
  alias SlackInviter.SlackApi

  require Logger

  @clearbit_configured !!Application.get_env(:slack_inviter, :clearbit_api_key)

  def notify_slack(email) do
    if @clearbit_configured do
      blocks = email
       |> Clearbit.lookup
       |> build_blocks

      {:ok, %{body: response}} = SlackApi.notify_invited("Invited " <> email, blocks)
      parse_notify_slack email, response
    else
      {:ok, %{body: response}} = SlackApi.notify_invited("Invited " <> email)
      parse_notify_slack email, response
    end
  end

  defp parse_notify_slack(email, response) do
    case response do
      %{"ok" => true} ->
        {:ok, "success"}
      %{"ok" => false} ->
        Logger.error "Could not send notification to slack: " <> email <> " : " <> response["error"]
        {:error, response["error"]}
    end
  end

  defp build_blocks(person) do
    EEx.eval_string(build_message(), person: person)
    |> String.replace(~r/\n$/m, "")
    |> blocks_section(person.email, person.avatar)
  end

  defp build_message do
    """
    > *<%= person.name %>*
    <%= if person.location do %>> <%= person.location %><% end %>
    <%= if person.employer do %>> <%= person.title %> @ <%= person.employer %><% end %>
    <%= if person.bio do %>> _<%= person.bio %>_ <% end %>
    <%= if person.twitter_handle do %>> https://twitter.com/<%= person.twitter_handle %> (<%= person.twitter_followers %> followers)<% end %>
    """
  end

  defp blocks_section(text, email, image) do
    EEx.eval_string("""
      [{
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "Invitation sent to: <%= email %>"
        }
      },
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "<%= text %>"
      }<%= if image do %>,
        "accessory": {
          "type": "image",
          "image_url": "<%= image %>",
          "alt_text": "avatar"
        } <% end %>
      }]
    """, text: text, email: email, image: image)
  end
end

