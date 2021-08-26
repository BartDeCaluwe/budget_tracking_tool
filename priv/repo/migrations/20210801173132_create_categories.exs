defmodule BudgetTrackingTool.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :label, :string

      timestamps()
    end
  end
end
