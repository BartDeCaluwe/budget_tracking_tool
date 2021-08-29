defmodule BudgetTrackingTool.Accounts.Org do
  use Ecto.Schema
  import Ecto.Changeset

  alias BudgetTrackingTool.Accounts.{User, UserOrg}

  schema "orgs" do
    field :name, :string

    many_to_many :users, User, join_through: UserOrg

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
