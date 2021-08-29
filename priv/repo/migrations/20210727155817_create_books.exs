defmodule BudgetTrackingTool.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :name, :string
      add :org_id, references(:orgs), null: false

      timestamps()
    end

    create unique_index(:books, [:id, :org_id])
  end
end
