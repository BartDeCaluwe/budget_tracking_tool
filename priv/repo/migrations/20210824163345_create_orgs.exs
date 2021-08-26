defmodule BudgetTrackingTool.Repo.Migrations.CreateOrgs do
  use Ecto.Migration

  def change do
    create table(:orgs, primary_key: false) do
      add :org_id, :id, primary_key: true
      add :name, :string

      timestamps()
    end
  end
end
