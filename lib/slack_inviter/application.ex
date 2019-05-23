defmodule SlackInviter.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = case Mix.env do
      :test -> [
        supervisor(SlackInviterWeb.Endpoint, []),
        {Plug.Cowboy, scheme: :http, plug: MockServers.FakeSlack, options: [port: 18081]},
        {Plug.Cowboy, scheme: :http, plug: MockServers.FakeClearbit, options: [port: 18082]},
      ]
      _ -> [
        supervisor(SlackInviterWeb.Endpoint, []),
      ]
    end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SlackInviter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SlackInviterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
