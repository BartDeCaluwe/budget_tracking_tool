defmodule BudgetTrackingTool.Repo.Migrations.CreatePayees do
  use Ecto.Migration

  def change do
    create table(:payees) do
      add :name, :string
      add :org_id, references(:orgs), null: false

      timestamps()
    end
  end
end
