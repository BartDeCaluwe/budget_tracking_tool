defmodule BudgetTrackingToolWeb.PutOrgId do
  import Phoenix.LiveView

  # Ensures org_id is set on all LiveViews
  # that attach this module as an `on_mount` hook
  def mount(_params, session, socket) do
    BudgetTrackingTool.Accounts.get_user_by_session_token(Map.get(session, "user_token"))
    |> BudgetTrackingTool.Accounts.list_user_orgs()
    |> Enum.at(0)
    |> BudgetTrackingTool.Repo.put_org_id()

    {:cont, socket}
  end
end
