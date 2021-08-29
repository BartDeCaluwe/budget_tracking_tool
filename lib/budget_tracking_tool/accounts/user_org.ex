defmodule BudgetTrackingTool.Accounts.UserOrg do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "users_orgs" do
    belongs_to :user, BudgetTrackingTool.Accounts.User
    belongs_to :org, BudgetTrackingTool.Accounts.Org
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :org_id])
    |> validate_required([:user_id, :org_id])
  end
end
