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
    |> Repo.preload([:category, :book, :payee])
  end

  def list_transactions(%{order_direction: direction, order_field: order_field}) do
    query = ordered_query(direction, order_field)

    Repo.all(query)
    |> Repo.preload([:category, :book, :payee])
  end

  def list_transactions(%{order_direction: direction, order_field: order_field}, criteria) when is_list(criteria) do
    query = ordered_query(direction, order_field)

    Enum.reduce(criteria, query, fn
      {:min_amount, nil}, query ->
        query

      {:min_amount, min_amount}, query ->
        from q in query, where: q.amount >= ^min_amount

      {:max_amount, nil}, query ->
        query

      {:max_amount, max_amount}, query ->
        from q in query, where: q.amount <= ^max_amount

      {:description, nil}, query ->
        query

      {:description, description}, query ->
        from q in query, where: ilike(q.description, ^"%#{String.replace(description, "%", "\\%")}%")

      {:payee, %{id: 0}}, query ->
        query

      {:payee, payee}, query ->
        from q in query,
          where: q.payee_id == ^payee.id

      {:category, %{id: 0}}, query ->
        query

      {:category, category}, query ->
        from q in query,
          where: q.category_id == ^category.id

      {:show_claimable, nil}, query ->
        query

      {:show_claimable, show_claimable}, query ->
        from q in query, where: q.is_claimable == ^show_claimable
    end)
    |> Repo.all()
    |> Repo.preload([:category, :book, :payee])
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
        select: t,
        order_by: t.date
    )
    |> Repo.preload([:category, :book, :payee])
  end

  def list_transactions(month, year, book_id, category_id) do
    beginning_of_month = Dates.beginning_of_month(month, year)
    end_of_month = Dates.end_of_month(month, year)

    Repo.all(
      from t in Transaction,
        where:
          t.book_id == ^book_id and
            t.category_id == ^category_id and
            t.date >= ^beginning_of_month and
            t.date <= ^end_of_month,
        select: t,
        order_by: t.date
    )
    |> Repo.preload([:category, :book, :payee])
  end

  def list_claimable_transactions(month, year, book_id, category_id) do
    end_of_month = Dates.end_of_month(month, year)

    Repo.all(
      from t in Transaction,
        where:
          t.book_id == ^book_id and
            t.category_id == ^category_id and
            t.date <= ^end_of_month and
            t.is_claimable == true and
            is_nil(t.claimed_at),
        select: t
    )
    |> Repo.preload([:category, :book, :payee])
  end

  defp ordered_query(direction, order_field) do
    case String.split(order_field, ".") do
      [association, field] ->
        association = String.to_atom(association)
        order_field = String.to_atom(field)

        from(
          t in Transaction,
          left_join: a in assoc(t, ^association),
          order_by: [{^direction, field(a, ^order_field)}]
        )

      [field] ->
        order_field = String.to_atom(field)

        from(
          t in Transaction,
          order_by: [{^direction, field(t, ^order_field)}]
        )
    end
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
    do: Repo.get!(Transaction, id) |> Repo.preload([:category, :book, :payee])

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

  def claim_transaction(%Transaction{} = transaction) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    # set claimed date
    # set claimed amount?
    # add claimed amount to category balance
    transaction
    |> Transaction.changeset(%{
      claimed_at: now
    })
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

    total_income = total_income_up_to(end_of_month, book_id)
    total_expenses = total_expenses_for_month(month, year, book_id)

    book = Books.get_book!(book_id)

    book.starting_balance.amount + total_income - total_expenses
  end

  defp total_expenses_for_month(month, year, book_id) do
    get_expense_transactions(month, year, book_id)
    |> calculate_total_transaction_amount()
  end

  defp get_expense_transactions(month, year, book_id) do
    end_of_month = Dates.end_of_month(month, year)
    naive_end_of_month = Dates.naive_end_of_month(month, year)

    Repo.all(
      from t in Transaction,
        left_join: c in Category,
        on: c.id == t.category_id,
        where:
          t.book_id == ^book_id and
            c.is_income == false and
            t.date <= ^end_of_month and
            (is_nil(t.claimed_at) or t.claimed_at > ^naive_end_of_month),
        select: t
    )
  end

  defp calculate_total_transaction_amount([]), do: 0

  defp calculate_total_transaction_amount(transactions) do
    Enum.reduce(transactions, 0, fn transaction, acc -> transaction.amount.amount + acc end)
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
            t.date <= ^end_of_month and
            (is_nil(t.claimed_at) or
               (^month < fragment("date_part('month', ?)", t.claimed_at) and
                  ^year <= fragment("date_part('year', ?)", t.claimed_at))),
        select: t
    )
    |> Enum.reduce(0, fn t, acc -> acc + t.amount.amount end)
  end

  defp total_overspent(amount) when amount >= 0, do: 0
  defp total_overspent(amount) when amount < 0, do: abs(amount)
end
