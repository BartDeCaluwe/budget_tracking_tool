defmodule BudgetTrackingTool.Payees.Payee do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payees" do
    field :name, :string

    belongs_to :org, BudgetTrackingTool.Accounts.Org

    timestamps()
  end

  @doc false
  def changeset(payee, attrs) do
    payee
    |> cast(attrs, [:name, :org_id])
    |> validate_required([:name, :org_id])
  end
end
