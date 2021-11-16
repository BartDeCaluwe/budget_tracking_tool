defmodule BudgetTrackingTool.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :amount, Money.Ecto.Amount.Type
    field :date, :date
    field :description, :string
    field :is_claimable, :boolean, default: false
    field :claimed_at, :naive_datetime

    belongs_to :org, BudgetTrackingTool.Accounts.Org
    belongs_to :category, BudgetTrackingTool.Categories.Category
    belongs_to :payee, BudgetTrackingTool.Payees.Payee
    belongs_to :book, BudgetTrackingTool.Books.Book

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [
      :description,
      :amount,
      :date,
      :is_claimable,
      :claimed_at,
      :category_id,
      :payee_id,
      :book_id,
      :org_id
    ])
    |> validate_required([:amount, :date, :is_claimable, :category_id, :book_id, :org_id])
  end

  def change(changeset, field, value) do
    put_change(changeset, field, value)
  end
end
