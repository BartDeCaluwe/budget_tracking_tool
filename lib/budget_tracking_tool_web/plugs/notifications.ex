defmodule BudgetTrackingToolWeb.Plugs.Notifications do
  import Plug.Conn

  alias BudgetTrackingTool.Accounts

  def init(default), do: default

  def call(%{current_user: current_user} = conn, _default) do
    notifications = Accounts.list_pending_org_invites_for_user(current_user)
    assign(conn, :notifications, notifications)
  end

  def call(conn, _default) do
    assign(conn, :notifications, [])
  end
end
