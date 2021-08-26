defmodule BudgetTrackingTool.Repo.Migrations.AddBookToTransaction do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :book_id, references(:books)
    end
  end
end
