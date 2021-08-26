defmodule BudgetTrackingTool.Repo.Migrations.AddIsIncomeToCategory do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :is_income, :boolean
    end
  end
end
