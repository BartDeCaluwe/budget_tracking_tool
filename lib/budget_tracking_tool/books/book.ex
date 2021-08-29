defmodule BudgetTrackingTool.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :name, :string

    belongs_to :org, BudgetTrackingTool.Accounts.Org
    has_many :budgets, BudgetTrackingTool.Budgets.Budget

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:name, :org_id])
    |> validate_required([:name, :org_id])
  end
end
