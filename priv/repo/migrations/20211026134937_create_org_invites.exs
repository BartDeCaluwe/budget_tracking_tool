defmodule BudgetTrackingTool.Repo.Migrations.CreateOrgInvites do
  use Ecto.Migration

  def change do
    create table(:org_invites) do
      add :status, :string
      add :email, :string
      add :user_id, references(:users, on_delete: :delete_all)
      add :org_id, references(:orgs, on_delete: :delete_all)

      timestamps()
    end

    create index(:org_invites, [:email])
    create index(:org_invites, [:user_id])
    create index(:org_invites, [:org_id])
  end
end
