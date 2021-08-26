defmodule BudgetTrackingTool.Budgets do
  @moduledoc """
  The Budgets context.
  """

  import Ecto.Query, warn: false
  use Timex

  alias BudgetTrackingTool.Repo

  alias BudgetTrackingTool.Dates
  alias BudgetTrackingTool.Budgets.Budget
  alias BudgetTrackingTool.Transactions
  alias BudgetTrackingTool.Categories.Category

  @doc """
  Returns the list of budgets.

  ## Examples

      iex> list_budgets()
      [%Budget{}, ...]

  """
  def list_budgets do
    Repo.all(Budget)
    |> Repo.preload(:book)
    |> Repo.preload(:category)
  end

  def list_budgets(month, year, book_id) do
    date = Timex.to_date({year, month, 1})
    start_of_month = date |> Timex.beginning_of_month()
    end_of_month = date |> Timex.end_of_month()

    Repo.all(
      from b in Budget,
        where:
          b.book_id == ^book_id and
            b.date >= ^start_of_month and
            b.date <= ^end_of_month,
        select: b
    )
    |> Repo.preload(:book)
    |> Repo.preload(:category)
  end

  @doc """
  Gets a single budget.

  Raises `Ecto.NoResultsError` if the Budget does not exist.

  ## Examples

      iex> get_budget!(123)
      %Budget{}

      iex> get_budget!(456)
      ** (Ecto.NoResultsError)

  """
  def get_budget!(id), do: Repo.get!(Budget, id)

  @doc """
  Creates a budget.

  ## Examples

      iex> create_budget(%{field: value})
      {:ok, %Budget{}}

      iex> create_budget(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_budget(attrs \\ %{}) do
    %Budget{}
    |> Budget.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a budget.

  ## Examples

      iex> update_budget(budget, %{field: new_value})
      {:ok, %Budget{}}

      iex> update_budget(budget, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_budget(%Budget{} = budget, attrs) do
    budget
    |> Budget.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a budget.

  ## Examples

      iex> delete_budget(budget)
      {:ok, %Budget{}}

      iex> delete_budget(budget)
      {:error, %Ecto.Changeset{}}

  """
  def delete_budget(%Budget{} = budget) do
    Repo.delete(budget)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking budget changes.

  ## Examples

      iex> change_budget(budget)
      %Ecto.Changeset{data: %Budget{}}

  """
  def change_budget(%Budget{} = budget, attrs \\ %{}) do
    Budget.changeset(budget, attrs)
  end

  def calculate_available_for_month(month, year, category_id, book_id) do
    end_of_month = Dates.end_of_month(month, year)

    total_budgetted =
      Repo.all(
        from b in Budget,
          where:
            b.book_id == ^book_id and
              b.category_id == ^category_id and
              b.date <= ^end_of_month,
          select: b
      )
      |> Enum.reduce(0, fn b, acc -> acc + b.amount end)

    total_expenses =
      Transactions.calculate_expenses_for_month(
        month,
        year,
        book_id,
        category_id
      )

    total_budgetted - total_expenses
  end

  def calculate_deductable_for_month(month, year, book_id) do
    beginning_of_month = Dates.beginning_of_month(month, year)

    Repo.all(
      from b in Budget,
        join: c in Category,
        on: c.id == b.category_id,
        where:
          b.book_id == ^book_id and
            c.overspent_behavior == :deduct and
            b.date < ^beginning_of_month,
        select: b
    )
    |> Enum.reduce(0, fn b, acc -> acc + b.amount end)
  end

  def calculate_budgetted_for_month(month, year, book_id) do
    Dates.end_of_month(month, year)
    |> total_budgetted_up_to(book_id)
  end

  defp total_budgetted_up_to(date, book_id) do
    Repo.all(
      from b in Budget,
        where:
          b.book_id == ^book_id and
            b.date <= ^date,
        select: b
    )
    |> Enum.reduce(0, fn b, acc -> acc + b.amount end)
  end
end
