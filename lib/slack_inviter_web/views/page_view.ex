defmodule SlackInviterWeb.PageView do
  use SlackInviterWeb, :view

  def active_member_count(%{active: active}), do: active
  def active_member_count(_), do: 0

  def total_member_count(%{active: active, away: away}), do: active + away
  def total_member_count(_), do: 0
end

