defmodule BudgetTrackingTool.Repo.Migrations.BudgetBelongsToBook do
  use Ecto.Migration

  def change do
    alter table(:budgets) do
      add :book_id, references(:books)
    end
  end
end
