defmodule BudgetTrackingTool.Budgets.Budget do
  use Ecto.Schema
  import Ecto.Changeset

  schema "budgets" do
    field :amount, :integer
    field :date, :date

    belongs_to :org, BudgetTrackingTool.Accounts.Org
    belongs_to :category, BudgetTrackingTool.Categories.Category
    belongs_to :book, BudgetTrackingTool.Books.Book

    timestamps()
  end

  @doc false
  def changeset(budget, attrs) do
    budget
    |> cast(attrs, [:amount, :date, :category_id, :book_id, :org_id])
    |> validate_required([:amount, :date, :category_id, :book_id, :org_id])
  end
end
