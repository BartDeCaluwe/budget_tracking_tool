defmodule BudgetTrackingTool.Repo do
  use Ecto.Repo,
    otp_app: :budget_tracking_tool,
    adapter: Ecto.Adapters.Postgres
end
