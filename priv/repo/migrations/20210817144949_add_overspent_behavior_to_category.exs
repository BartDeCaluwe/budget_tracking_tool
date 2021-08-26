defmodule BudgetTrackingTool.Repo.Migrations.AddOverspentBehaviorToCategory do
  use Ecto.Migration

  def change do
    create_query = "CREATE TYPE overspent_behavior AS ENUM ('deduct', 'carry_over')"
    drop_query = "DROP TYPE overspent_behavior"
    execute(create_query, drop_query)

    alter table(:categories) do
      add :overspent_behavior, :overspent_behavior
    end
  end
end
