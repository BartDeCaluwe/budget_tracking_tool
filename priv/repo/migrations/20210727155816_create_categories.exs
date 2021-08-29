defmodule BudgetTrackingTool.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create_query = "CREATE TYPE overspent_behavior AS ENUM ('deduct', 'carry_over')"
    drop_query = "DROP TYPE overspent_behavior"
    execute(create_query, drop_query)

    create table(:categories) do
      add :label, :string
      add :is_income, :boolean
      add :overspent_behavior, :overspent_behavior
      add :org_id, references(:orgs), null: false

      timestamps()
    end

    create unique_index(:categories, [:id, :org_id])
  end
end
