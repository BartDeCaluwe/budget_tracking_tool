defmodule BudgetTrackingTool.Repo.Migrations.AddDeleteAllToCategoryTransactions do
  use Ecto.Migration

  def up do
    drop constraint(:transactions, "transactions_category_id_fkey")
    alter table(:transactions) do
      modify :category_id, references(:categories, on_delete: :delete_all, with: [org_id: :org_id]), null: false
    end
  end

  def down do
    drop constraint(:transactions, "transactions_category_id_fkey")
    alter table(:transactions) do
      modify :category_id, references(:categories, on_delete: :nothing, with: [org_id: :org_id]), null: false
    end
  end
end
