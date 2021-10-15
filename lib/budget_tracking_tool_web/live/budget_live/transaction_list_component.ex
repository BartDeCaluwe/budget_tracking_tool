defmodule BudgetTrackingToolWeb.BudgetLive.TransactionListComponent do
  use BudgetTrackingToolWeb, :live_component

  alias BudgetTrackingTool.Budgets

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flow-root">
      <ul role="list" class="-mb-8">
        <%= for {transaction, index} <- Enum.with_index(@transactions, 1) do %>
          <li>
            <div class="relative pb-8">
              <%= if index !== length(@transactions) do %>
                <span class="absolute top-4 left-4 -ml-px h-full w-0.5 bg-gray-200" aria-hidden="true"></span>
              <% end %>
              <div class="relative flex space-x-3">
                <div>
                  <span class="h-8 w-8 rounded-full bg-gray-400 flex items-center justify-center ring-8 ring-white">
                    <!-- Heroicon name: solid/user -->
                    <svg class="h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                      <path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd" />
                    </svg>
                  </span>
                </div>
                <div class="min-w-0 flex-1 pt-1.5 flex justify-between items-center space-x-4">
                  <div class="flex items-center space-x-2">
                    <div class="text-sm whitespace-nowrap text-gray-500">
                      <time datetime={transaction.date}><%= transaction.date %></time>
                    </div>
                    <p class="text-sm text-gray-500"><%= transaction.description %></p>
                  </div>
                  <a href="#" class="font-medium text-gray-900"><%= transaction.amount %></a>
                </div>
              </div>
            </div>
          </li>
        <% end %>
      </ul>
    </div>
    """
  end
end
