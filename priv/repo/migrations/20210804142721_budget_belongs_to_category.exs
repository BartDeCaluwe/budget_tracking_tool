defmodule BudgetTrackingTool.Repo.Migrations.BudgetBelongsToCategory do
  use Ecto.Migration

  def change do
    alter table(:budgets) do
      add :category_id, references(:categories)
    end
  end
end
