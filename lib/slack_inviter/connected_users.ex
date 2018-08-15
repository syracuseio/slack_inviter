defmodule SlackInviter.ConnectedUsers do
  @moduledoc """
  A module that connects to the slack api via websockets and listens for `presence_change` events.
  When it receives one, it adjusts the state of the UserPresenceAgent to reflect the number of
  online users and broadcasts this value to all clients via an phoenix channel.
  """
  use WebSockex

  alias SlackInviter.UserPresenceAgent

  def start_link(_) do
    case SlackInviter.SlackApi.rtm_connect do
      {:ok, %{body: response}} -> WebSockex.start_link(response["url"], __MODULE__, "")
      error -> error
    end
  end

  def handle_frame({_type, msg}, _state) do
    case Poison.decode(msg) do
      {:ok, state} ->
        aggregate_presence(state)
        {:ok, state}
      {:error, err} -> {:error, err}
    end
  end

  def aggregate_presence(%{
    "type" => "presence_change",
    "users" => users,
    "presence" => presence,
  }) do
    user_count = Enum.count(users)
    case presence do
      "away" -> UserPresenceAgent.decrement(user_count)
      "active" -> UserPresenceAgent.increment(user_count)
      _ -> :error
    end
  end

  def aggregate_presence(%{
    "type" => "presence_change",
    "presence" => presence,
  }) do
    case presence do
      "away" -> UserPresenceAgent.decrement(1)
      "active" -> UserPresenceAgent.increment(1)
      _ -> :error
    end
  end

  def handle_cast({:send, {type, msg} = frame}, state) do
    IO.puts "Sending #{type} frame with payload: #{msg}"
    {:reply, frame, state}
  end
end
