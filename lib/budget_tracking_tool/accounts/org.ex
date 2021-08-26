defmodule BudgetTrackingTool.Accounts.Org do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orgs" do
    field :name, :string

    many_to_many :users, BudgetTrackingTool.Accounts.User, join_through: "user_org"

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
