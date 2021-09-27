defmodule BudgetTrackingTool.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :amount, Money.Ecto.Amount.Type
    field :date, :date
    field :description, :string

    belongs_to :org, BudgetTrackingTool.Accounts.Org
    belongs_to :category, BudgetTrackingTool.Categories.Category
    belongs_to :book, BudgetTrackingTool.Books.Book

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:description, :amount, :date, :category_id, :book_id, :org_id])
    |> validate_required([:description, :amount, :date, :category_id, :book_id, :org_id])
  end

  def change(changeset, field, value) do
    put_change(changeset, field, value)
  end
end
