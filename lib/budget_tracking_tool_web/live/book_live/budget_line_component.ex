defmodule BudgetLineComponent do
  use BudgetTrackingToolWeb, :live_component

  alias BudgetTrackingTool.Budgets
  alias BudgetTrackingTool.Categories.Category

  def render(
        %{
          category: category,
          transactions: transactions,
          budget: budget,
          book_id: book_id
        } = assigns
      ) do
    available_in_category = available_in_category(category, budget, transactions, book_id)

    ~L"""
      <tr id="category-<%= category.id %>" x-data="{ open: false }">
        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
          <%= category.label %>
        </td>
        <td @click="open = true; $nextTick(() => { setTimeout(() => { document.getElementById('category-<%= category.id %>-budget-input').select(); }, 10);});")"
            @click.outside="open = false"
            id="category-<%= category.id %>-budget"
            class="h-[55px] whitespace-nowrap text-sm text-gray-500 text-right">
          <div x-show="open">
            <%= live_component BudgetTrackingToolWeb.BudgetLive.FormComponent,
              id: "category-#{category.id}-budget-input",
              action: get_action(budget.id),
              category_id: category.id,
              budget: budget,
              return_to: @return_to %>
          </div>
          <div x-show="!open" class="px-6 py-4"><%= budget.amount %></div>
        </td>
        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-right">
          <%= spent_in_category(transactions) %>
        </td>
        <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium <%= if available_in_category < 0, do: "text-red-500" %>">
          <%= available_in_category %>
        </td>
      </tr>
    """
  end

  def available_in_category(
        %Category{overspent_behavior: :deduct},
        budget,
        transactions,
        _book_id
      ) do
    budget.amount - spent_in_category(transactions)
  end

  def available_in_category(
        %Category{overspent_behavior: :carry_over} = category,
        budget,
        _transactions,
        book_id
      ) do
    Budgets.calculate_available_for_month(
      budget.date.month(),
      budget.date.year(),
      category.id,
      book_id
    )
  end

  def spent_in_category(transactions) do
    transactions
    |> total_amount()
  end

  defp total_amount([]), do: 0

  defp total_amount(transactions) do
    transactions
    |> Enum.map(& &1.amount)
    |> Enum.reduce(fn t, acc -> acc + t end)
  end

  defp get_action(nil) do
    :new
  end

  defp get_action(_) do
    :edit
  end
end
