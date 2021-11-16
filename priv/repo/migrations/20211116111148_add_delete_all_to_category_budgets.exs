defmodule BudgetTrackingTool.Repo.Migrations.AddDeleteAllToCategoryBudgets do
  use Ecto.Migration

  def up do
    drop constraint(:budgets, "budgets_category_id_fkey")
    alter table(:budgets) do
      modify :category_id, references(:categories, on_delete: :delete_all, with: [org_id: :org_id]), null: false
    end
  end

  def down do
    drop constraint(:budgets, "budgets_category_id_fkey")
    alter table(:budgets) do
      modify :category_id, references(:categories, on_delete: :nothing, with: [org_id: :org_id]), null: false
    end
  end
end
