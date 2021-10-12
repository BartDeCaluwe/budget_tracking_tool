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

  def list_transactions(order_params) do
    query = from(t in Transaction)

    query =
      query
      |> add_order_by(order_params)

    Repo.all(query)
    |> Repo.preload([:category, :book])
  end

  defp add_order_by(query, %{order_direction: :asc, order_by: order_by}) do
    from t in query,
      order_by: [asc: field(t, ^order_by)]
  end

  defp add_order_by(query, %{order_direction: :desc, order_by: order_by}) do
    from t in query,
      order_by: [desc: field(t, ^order_by)]
  end

  def list_transactions(order_params, criteria) when is_list(criteria) do
    query =
      from(t in Transaction)
      |> add_order_by(order_params)

    Enum.reduce(criteria, query, fn
      {:min_amount, ""}, query ->
        query

      {:min_amount, min_amount}, query ->
        from q in query, where: q.amount >= ^min_amount

      {:max_amount, ""}, query ->
        query

      {:max_amount, max_amount}, query ->
        from q in query, where: q.amount <= ^max_amount

      {:description, ""}, query ->
        query

      {:description, description}, query ->
        from q in query, where: ilike(q.description, ^"%#{String.replace(description, "%", "\\%")}%")

      {:category, %{id: 0}}, query ->
        query

      {:category, category}, query ->
        from q in query,
          join: c in Category,
          on: c.id == q.category_id,
          where: q.id == ^category.id
    end)
    |> Repo.all()
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
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
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
    Repo.delete(transaction)
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
    |> Enum.reduce(0, fn t, acc -> acc + t.amount.amount end)
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
    |> Enum.reduce(0, fn t, acc -> acc + t.amount.amount end)
  end

  def calculate_balance_for_month(month, year, book_id) do
    end_of_month = Dates.end_of_month(month, year)
    book = Books.get_book!(book_id)

    Repo.all(
      from t in Transaction,
        where:
          t.book_id == ^book.id and
            t.date <= ^end_of_month,
        select: t
    )
    |> Repo.preload([:category])
    |> Enum.reduce(book.starting_balance.amount, fn t, acc ->
      if t.category.is_income, do: acc + t.amount.amount, else: acc - t.amount.amount
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
    |> Enum.reduce(0, fn t, acc -> acc + t.amount.amount end)
  end

  defp total_overspent(amount) when amount >= 0, do: 0
  defp total_overspent(amount) when amount < 0, do: abs(amount)
end
