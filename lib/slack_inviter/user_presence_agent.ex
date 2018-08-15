defmodule SlackInviter.UserPresenceAgent do
  @moduledoc """
  This agent is used for keeping track of the number of users online at a given time. When a new
  user comes online, the increment/1 and decrement/1 methods are called to adjust the user count
  and broadcast the latest to all clients connected via an phoenix channel.
  """
  @name __MODULE__

  alias SlackInviterWeb.Endpoint

  def start_link(_) do
    Agent.start_link(fn -> 0 end, name: @name)
  end

  def increment(n) do
    case Agent.update(@name, fn(state) -> state + n end) do
      {:ok, pid} ->
        Endpoint.broadcast("user_presence:lobby", "users_change", assemble_payload())
        {:ok, pid}
      error -> error
    end
  end

  def decrement(n) do
    case Agent.update(@name, fn(state) -> state - n end) do
      {:ok, pid} ->
        Endpoint.broadcast("user_presence:lobby", "users_change", assemble_payload())
        {:ok, pid}
      error -> error
    end
  end
  
  def assemble_payload do
    %{
      "online_count" => get()
    }
  end

  def get do
    Agent.get(@name, fn(state) -> state end)
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end
end
