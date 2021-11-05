defmodule BudgetTrackingTool.Repo.Migrations.AddPayeeToTransaction do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :payee_id, references(:payees)
    end
  end
end
