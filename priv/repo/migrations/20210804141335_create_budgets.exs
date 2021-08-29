defmodule BudgetTrackingTool.Repo.Migrations.CreateBudgets do
  use Ecto.Migration

  def change do
    create table(:budgets) do
      add :amount, :integer
      add :date, :date
      add :org_id, references(:orgs), null: false
      add :category_id, references(:categories, with: [org_id: :org_id])
      add :book_id, references(:books, with: [org_id: :org_id])

      timestamps()
    end
  end
end
