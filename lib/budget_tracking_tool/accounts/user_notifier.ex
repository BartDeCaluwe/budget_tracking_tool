defmodule BudgetTrackingTool.Accounts.UserNotifier do
  use Phoenix.Swoosh, view: BudgetTrackingToolWeb.EmailView, layout: {BudgetTrackingToolWeb.LayoutView, :email}
  import Swoosh.Email
  alias BudgetTrackingTool.Mailer

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    new()
    |> to(user.email)
    |> from(Mailer.get_noreply_address())
    |> render_body("welcome.html", %{user: user, url: url})
    |> Mailer.deliver!()
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    new()
    |> to(user.email)
    |> from(Mailer.get_noreply_address())
    |> render_body("reset_password.html", %{user: user, url: url})
    |> Mailer.deliver!()
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    new()
    |> to(user.email)
    |> from(Mailer.get_noreply_address())
    |> render_body("update_email.html", %{user: user, url: url})
    |> Mailer.deliver!()
  end
end
