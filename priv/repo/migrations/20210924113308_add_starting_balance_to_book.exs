defmodule BudgetTrackingTool.Repo.Migrations.AddStartingBalanceToBook do
  use Ecto.Migration

  def change do
    alter table(:books) do
      add :starting_balance, :float, default: 0
    end
  end
end
