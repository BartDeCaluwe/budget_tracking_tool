defmodule BudgetTrackingTool.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  use Timex

  alias BudgetTrackingTool.Repo

  alias BudgetTrackingTool.Dates
  alias BudgetTrackingTool.Transactions.Transaction
  alias BudgetTrackingTool.Categories.Category
  alias BudgetTrackingTool.Books
  alias BudgetTrackingTool.Budgets

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
    |> Repo.preload([:category, :book])
  end

  def list_transactions(month, year, book_id) do
    beginning_of_month = Dates.beginning_of_month(month, year)
    end_of_month = Dates.end_of_month(month, year)

    Repo.all(
      from t in Transaction,
        where:
          t.book_id == ^book_id and
            t.date >= ^beginning_of_month and
            t.date <= ^end_of_month,
        select: t
    )
    |> Repo.preload([:category, :book])
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id),
    do: Repo.get!(Transaction, id) |> Repo.preload([:category, :book])

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    changeset = transaction |> Transaction.changeset(attrs)

    book_update = Books.update_book_query(transaction, changeset, transaction.category)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:transaction, changeset, [])
    |> Ecto.Multi.update_all(:book, book_update, [])
    |> Repo.transaction()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    book_update = Books.remove_transaction_from_book_query(transaction)

    Ecto.Multi.new()
    |> Ecto.Multi.delete(:transaction, transaction, [])
    |> Ecto.Multi.update_all(:book, book_update, [])
    |> Repo.transaction()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end

  def put_change(changeset, field, value) do
    Transaction.change(changeset, field, value)
  end

  def calculate_income_for_month(month, year, book_id) do
    end_of_month = Dates.end_of_month(month, year)
    total_income = total_income_up_to(end_of_month, book_id)
    total_budgetted = Budgets.calculate_budgetted_for_month(month, year, book_id)
    total_overspent = total_overspent(calculate_leftover_budget_for_month(month, year, book_id))
    total_income - total_budgetted - total_overspent
  end

  defp total_income_up_to(date, book_id) do
    Repo.all(
      from t in Transaction,
        join: c in Category,
        on: c.id == t.category_id,
        where:
          t.book_id == ^book_id and
            c.is_income == true and
            t.date <= ^date,
        select: t
    )
    |> Enum.reduce(0, fn t, acc -> acc + t.amount end)
  end

  def calculate_leftover_budget_for_month(month, year, book_id) do
    total_deductable_transactions =
      Dates.beginning_of_month(month, year)
      |> total_deductable_transactions_up_to(book_id)

    total_deductable_budgets = Budgets.calculate_deductable_for_month(month, year, book_id)

    total_deductable_budgets - total_deductable_transactions
  end

  def total_deductable_transactions_up_to(date, book_id) do
    Repo.all(
      from t in Transaction,
        join: c in Category,
        on: c.id == t.category_id,
        where:
          t.book_id == ^book_id and
            c.overspent_behavior == :deduct and
            c.is_income == false and
            t.date < ^date,
        select: t
    )
    |> Enum.reduce(0, fn t, acc -> acc + t.amount end)
  end

  def calculate_balance_for_month(month, year, book_id) do
    end_of_month = Dates.end_of_month(month, year)

    Repo.all(
      from t in Transaction,
        where:
          t.book_id == ^book_id and
            t.date <= ^end_of_month,
        select: t
    )
    |> Repo.preload([:category])
    |> Enum.reduce(0, fn t, acc ->
      if t.category.is_income, do: acc + t.amount, else: acc - t.amount
    end)
  end

  def calculate_expenses_for_month(month, year, book_id, category_id) do
    end_of_month = Dates.end_of_month(month, year)

    Repo.all(
      from t in Transaction,
        join: c in Category,
        on: c.id == ^category_id,
        where:
          t.book_id == ^book_id and
            c.is_income == false and
            t.category_id == ^category_id and
            t.date <= ^end_of_month,
        select: t
    )
    |> Enum.reduce(0, fn t, acc -> acc + t.amount end)
  end

  defp total_overspent(amount) when amount >= 0, do: 0
  defp total_overspent(amount) when amount < 0, do: abs(amount)
end
