# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :slack_inviter, SlackInviterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3EFG7Xa7OttSkFaMX2tKTRXRH+NBU21/VATCQGO3MKoKAdNficxXQ14Ckc/inONT",
  render_errors: [view: SlackInviterWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SlackInviter.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :slack_inviter,
  slack_api_base_url: System.get_env("SLACK_API_BASE") || "https://slack.com/api",
  slack_api_token: System.get_env("SLACK_API_TOKEN")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

