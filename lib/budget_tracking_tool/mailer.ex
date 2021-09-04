defmodule BudgetTrackingTool.Mailer do
  use Swoosh.Mailer, otp_app: :budget_tracking_tool

  @default_sender "info@bdcit.be"

  def get_default_sender, do: @default_sender
end
