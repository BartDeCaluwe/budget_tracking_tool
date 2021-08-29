defmodule BudgetTrackingTool.Repo.Migrations.CreateUserOrgs do
  use Ecto.Migration

  def change do
    create table(:users_orgs) do
      add :user_id, references(:users)
      add :org_id, references(:orgs)

      timestamps()
    end
  end
end
