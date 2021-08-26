defmodule BudgetTrackingToolWeb.CategoryLive.LabelComponent do
  use BudgetTrackingToolWeb, :live_component

  def render(%{category: category, selected: selected} = assigns) do
    ~L"""
      <div class="flex items-center">
        <span class="<%= if category.is_income, do: "bg-green-400", else: "bg-red-400" %> flex-shrink-0 inline-block h-2 w-2 rounded-full" aria-hidden="true"></span>
        <span class="<%= if selected, do: "font-semibold", else: "font-normal" %> ml-3 block truncate">
          <%= category.label %>
          <%= if category.is_income do %>
            <span class="sr-only"> is income</span>
          <% end %>
        </span>
      </div>
    """
  end

  def render(%{category: category} = assigns) do
    ~L"""
      <div class="flex items-center">
        <span class="<%= if category.is_income, do: "bg-green-400", else: "bg-red-400" %> flex-shrink-0 inline-block h-2 w-2 rounded-full" aria-hidden="true"></span>
        <span class="ml-3"><%= category.label %></span>
        <%= if category.is_income do %>
          <span class="sr-only"> is income</span>
        <% end %>
      </div>
    """
  end
end
