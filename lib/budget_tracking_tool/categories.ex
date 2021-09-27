defmodule BudgetTrackingTool.Categories do
  @moduledoc """
  The Categories context.
  """

  import Ecto.Query, warn: false
  alias BudgetTrackingTool.Repo

  alias BudgetTrackingTool.Categories.Category

  @default_expense_categories ~w(Rent Groceries)
  @default_income_categories ~w(Paycheck)

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Category
    |> order_by(:is_income)
    |> order_by(:label)
    |> Repo.all()
  end

  def list_expense_categories do
    Repo.all(from c in Category, where: c.is_income == false)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  def create_default_categories(user) do
    %{id: id} = List.first(user.orgs)
    overspent_behavior = Enum.at(Category.overspent_behaviors(), 1)
    create_default_expense_categories(id, overspent_behavior)
    create_default_income_categories(id, overspent_behavior)
  end

  defp create_default_expense_categories(org_id, overspent_behavior) do
    Enum.each(@default_expense_categories, fn label ->
      %Category{}
      |> Category.changeset(%{label: label, is_income: false, overspent_behavior: overspent_behavior, org_id: org_id})
      |> Repo.insert()
    end)
  end

  defp create_default_income_categories(org_id, overspent_behavior) do
    Enum.each(@default_income_categories, fn label ->
      %Category{}
      |> Category.changeset(%{label: label, is_income: true, overspent_behavior: overspent_behavior, org_id: org_id})
      |> Repo.insert()
    end)
  end
end
