defmodule BudgetTrackingTool.Books do
  @moduledoc """
  The Books context.
  """

  import Ecto.Query, warn: false
  alias BudgetTrackingTool.Repo

  alias BudgetTrackingTool.Books.Book
  alias BudgetTrackingTool.Transactions.Transaction
  alias BudgetTrackingTool.Categories.Category

  @doc """
  Returns the list of books.

  ## Examples

      iex> list_books()
      [%Book{}, ...]

  """
  def list_books do
    Repo.all(Book)
  end

  @doc """
  Gets a single book.

  Raises `Ecto.NoResultsError` if the Book does not exist.

  ## Examples

      iex> get_book!(123)
      %Book{}

      iex> get_book!(456)
      ** (Ecto.NoResultsError)

  """
  def get_book!(id), do: Repo.get!(Book, id)
  def get_book!, do: Book |> first |> Repo.one

  @doc """
  Creates a book.

  ## Examples

      iex> create_book(%{field: value})
      {:ok, %Book{}}

      iex> create_book(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_book(attrs \\ %{}) do
    %Book{}
    |> Book.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a book.

  ## Examples

      iex> update_book(book, %{field: new_value})
      {:ok, %Book{}}

      iex> update_book(book, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_book(%Book{} = book, attrs) do
    book
    |> Book.changeset(attrs)
    |> Repo.update()
  end

  def update_book_query(
        %{changes: %{book_id: book_id, amount: amount}},
        %{is_income: true}
      ) do
      from b in Book,
        where: [id: ^book_id],
        update: [set: [balance: b.balance + ^amount]]
  end

  def update_book_query(
        %{changes: %{book_id: book_id, amount: amount}},
        %Category{is_income: false}
      ) do
      from b in Book,
        where: [id: ^book_id],
        update: [set: [balance: b.balance - ^amount]]
  end

  def update_book_query(
        %Transaction{} = transaction,
        %{changes: %{amount: amount}},
        %Category{is_income: true}
      ) do
      from b in Book,
        where: [id: ^transaction.book.id],
        update: [set: [balance: b.balance + ^amount - ^transaction.amount]]
  end

  def update_book_query(
        %Transaction{} = transaction,
        %{changes: %{amount: amount}},
        %Category{is_income: false}
      ) do
      from b in Book,
        where: [id: ^transaction.book.id],
        update: [set: [balance: b.balance + ^transaction.amount - ^amount]]
  end

  def remove_transaction_from_book_query(%Transaction{category: %{is_income: false}} = transaction) do
      from b in Book,
        where: [id: ^transaction.book.id],
        update: [set: [balance: b.balance + ^transaction.amount]]
  end

  def remove_transaction_from_book_query(%Transaction{category: %{is_income: true}} = transaction) do
      from b in Book,
        where: [id: ^transaction.book.id],
        update: [set: [balance: b.balance - ^transaction.amount]]
  end

  @doc """
  Deletes a book.

  ## Examples

      iex> delete_book(book)
      {:ok, %Book{}}

      iex> delete_book(book)
      {:error, %Ecto.Changeset{}}

  """
  def delete_book(%Book{} = book) do
    Repo.delete(book)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking book changes.

  ## Examples

      iex> change_book(book)
      %Ecto.Changeset{data: %Book{}}

  """
  def change_book(%Book{} = book, attrs \\ %{}) do
    Book.changeset(book, attrs)
  end
end
