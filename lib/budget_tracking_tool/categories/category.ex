defmodule BudgetTrackingTool.Categories.Category do
  use Ecto.Schema
  import Ecto.Changeset

  @overspent_behaviors [:deduct, :carry_over]

  schema "categories" do
    field :label, :string
    field :is_income, :boolean

    field :overspent_behavior, Ecto.Enum,
      values: @overspent_behaviors,
      default: @overspent_behaviors[:deduct]

    belongs_to :org, BudgetTrackingTool.Accounts.Org
    has_many :transactions, BudgetTrackingTool.Transactions.Transaction
    has_many :budgets, BudgetTrackingTool.Budgets.Budget

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:label, :is_income, :overspent_behavior, :org_id])
    |> validate_required([:label, :is_income, :overspent_behavior, :org_id])
  end

  def overspent_behaviors do
    @overspent_behaviors
  end
end
