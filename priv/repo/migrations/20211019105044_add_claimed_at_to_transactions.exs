defmodule BudgetTrackingTool.Repo.Migrations.AddClaimedAtToTransactions do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :claimed_at, :naive_datetime
    end
  end
end
