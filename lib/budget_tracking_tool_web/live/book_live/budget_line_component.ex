defmodule BudgetLineComponent do
  use BudgetTrackingToolWeb, :live_component

  alias BudgetTrackingTool.Budgets
  alias BudgetTrackingTool.Transactions
  alias BudgetTrackingTool.Categories.Category

  def render(
        %{
          category: category,
          transactions: transactions,
          budget: budget,
          book_id: book_id,
          date: date
        } = assigns
      ) do
    available_in_category = available_in_category(category, budget, transactions, book_id)

    ~H"""
      <tr id={"category#{category.id}"} x-data="{ open: false }">
        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
          <span><%= live_patch category.label, to: Routes.book_show_path(@socket, :transactions, @category.id, date: date), class: "hover:cursor-pointer hover:text-gray-900" %></span>
        </td>
        <td
            @click={"open = true; $nextTick(() => { setTimeout(() => { document.getElementById('category-#{category.id}-budget-input').select(); }, 10);});"}
            @click.outside="open = false"
            id={"category-#{category.id}-budget"}
            class="h-[55px] whitespace-nowrap text-sm text-gray-500 text-right">
          <div x-show="open">
            <%= live_component BudgetTrackingToolWeb.BudgetLive.FormComponent,
              id: "category-#{category.id}-budget-input",
              action: get_action(budget.id),
              category_id: category.id,
              budget: budget,
              return_to: @return_to %>
          </div>
          <div x-show="!open" class="px-6 py-2 my-2 font-mono rounded-md border-2 border-transparent hover:cursor-pointer hover:border-green-500"><%= budget.amount %></div>
        </td>
        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-right font-mono">
          <%= Money.new(spent_in_category(transactions)) %>
        </td>
        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 font-mono">
          <%= if claimable_in_category(category.id, budget, book_id) !== 0 do %>
            <%= live_patch to: Routes.book_show_path(@socket, :claimable, @category.id, date: date), class: "hover:cursor-pointer hover:text-gray-900" do %>
              <span class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-indigo-100 text-indigo-800">
              <%= Money.new(claimable_in_category(category.id, budget, book_id)) %>
              </span>
            <% end %>
          <% end %>
        </td>
        <td class={"px-6 py-4 whitespace-nowrap text-right text-sm font-medium font-mono #{get_available_text_color(available_in_category)}"}>
          <%= Money.new(available_in_category) %>
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
    budget.amount.amount - spent_in_category(transactions)
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

  def claimable_in_category(category_id, budget, book_id) do
    Transactions.list_claimable_transactions(
      budget.date.month(),
      budget.date.year(),
      book_id,
      category_id
    )
    |> total_amount()
  end

  defp total_amount([]), do: 0

  defp total_amount(transactions) do
    transactions
    |> Enum.map(& &1.amount.amount)
    |> Enum.reduce(fn t, acc -> acc + t end)
  end

  defp get_action(nil) do
    :new
  end

  defp get_action(_) do
    :edit
  end

  defp get_available_text_color(available) do
    if available < 0 do
      "text-red-500"
    end
  end
end
