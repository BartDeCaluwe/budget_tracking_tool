defmodule BudgetTrackingTool.Payees do
  @moduledoc """
  The Payees context.
  """

  import Ecto.Query, warn: false
  alias BudgetTrackingTool.Repo

  alias BudgetTrackingTool.Payees.Payee

  @doc """
  Returns the list of payees.

  ## Examples

      iex> list_payees()
      [%Payee{}, ...]

  """
  def list_payees do
    Repo.all(Payee)
  end

  @doc """
  Gets a single payee.

  Raises `Ecto.NoResultsError` if the Payee does not exist.

  ## Examples

      iex> get_payee!(123)
      %Payee{}

      iex> get_payee!(456)
      ** (Ecto.NoResultsError)

  """
  def get_payee!(id), do: Repo.get!(Payee, id)

  @doc """
  Creates a payee.

  ## Examples

      iex> create_payee(%{field: value})
      {:ok, %Payee{}}

      iex> create_payee(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_payee(attrs \\ %{}) do
    %Payee{}
    |> Payee.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a payee.

  ## Examples

      iex> update_payee(payee, %{field: new_value})
      {:ok, %Payee{}}

      iex> update_payee(payee, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_payee(%Payee{} = payee, attrs) do
    payee
    |> Payee.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a payee.

  ## Examples

      iex> delete_payee(payee)
      {:ok, %Payee{}}

      iex> delete_payee(payee)
      {:error, %Ecto.Changeset{}}

  """
  def delete_payee(%Payee{} = payee) do
    Repo.delete(payee)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking payee changes.

  ## Examples

      iex> change_payee(payee)
      %Ecto.Changeset{data: %Payee{}}

  """
  def change_payee(%Payee{} = payee, attrs \\ %{}) do
    Payee.changeset(payee, attrs)
  end
end
