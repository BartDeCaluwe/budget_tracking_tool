defmodule BudgetTrackingTool.Mailer do
  use Swoosh.Mailer, otp_app: :budget_tracking_tool

  @noreply_address "noreply@budgettrackingtool.com"

  def get_noreply_address, do: @noreply_address
end
