defmodule BudgetTrackingTool.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :description, :string
      add :amount, :integer
      add :date, :date
      add :org_id, references(:orgs), null: false
      add :category_id, references(:categories, with: [org_id: :org_id]), null: false
      add :book_id, references(:books, with: [org_id: :org_id]), null: false

      timestamps()
    end
  end
end
