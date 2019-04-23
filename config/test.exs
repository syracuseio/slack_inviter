use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :slack_inviter, SlackInviterWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :slack_inviter,
  slack_api_base_url: "http://localhost:8081",
  slack_api_token: "testt0ken"
