defmodule BudgetTrackingTool.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :description, :string
      add :amount, :integer
      add :date, :date

      timestamps()
    end
  end
end
