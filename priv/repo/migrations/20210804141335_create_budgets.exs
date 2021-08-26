defmodule BudgetTrackingTool.Repo.Migrations.CreateBudgets do
  use Ecto.Migration

  def change do
    create table(:budgets) do
      add :amount, :integer
      add :date, :date

      timestamps()
    end
  end
end
