defmodule BudgetTrackingToolWeb.OrgInviteController do
  use BudgetTrackingToolWeb, :controller

  alias BudgetTrackingTool.Accounts

  def accept(conn, %{"id" => id} = params) do
    Accounts.accept_org_invite(id, conn.assigns.current_user)
    org = Accounts.get_org!(id)

    BudgetTrackingTool.Repo.put_org_id(id)

    conn
    |> put_session(:org_id, id)
    |> put_flash(:info, "You're now part of #{org.name}")
    |> redirect(to: Routes.book_show_path(conn, :show))
  end

  def reject(conn, %{"id" => id} = params) do
    Accounts.reject_org_invite(id, conn.assigns.current_user)

    render(
      conn,
      "reject.html"
    )
  end
end
