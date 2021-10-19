defmodule BudgetTrackingTool.Repo.Migrations.AddIsClaimableToTransaction do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :is_claimable, :boolean, default: false
    end
  end
end
