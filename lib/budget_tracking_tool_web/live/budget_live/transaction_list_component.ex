defmodule BudgetTrackingToolWeb.BudgetLive.TransactionListComponent do
  use BudgetTrackingToolWeb, :live_component

  alias BudgetTrackingTool.Transactions

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
      <%= if Enum.empty?(@transactions) do %>
      <div class="mt-4">
        <BudgetTrackingToolWeb.Components.EmptyState.render
          title="No transactions"
          description="Get started by creating a new transaction."
          redirect_to={@return_to}
          button_text="New Transaction" />
      </div>
      <% else %>
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
                  <div class="flex items-center space-x-2">
                    <span class="font-medium text-gray-900"><%= transaction.amount %></span>
                    <button phx-click="claim" phx-value-transaction_id={"#{transaction.id}"} phx-target={@myself} type="button" class={"inline-flex items-center px-2.5 py-1.5 border border-gray-300 shadow-sm text-xs font-medium rounded text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 " <> if transaction.is_claimable, do: "visible", else: "invisible"}>
                      claim
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </li>
        <% end %>
      </ul>
      <% end %>
    </div>
    """
  end

  @impl true
  def handle_event("claim", %{"transaction_id" => transaction_id}, socket) do
    {id, _} = Integer.parse(transaction_id)

    Enum.find(socket.assigns.transactions, fn transaction -> transaction.id === id end)
    |> Transactions.claim_transaction()

    {:noreply, redirect(socket, to: socket.assigns.return_to)}
  end

  def footer(assigns) do
    ~H"""
      <div class="flex justify-end">
        <div class="text-gray-500">Total: <span class="font-medium text-gray-900">
          <%= Enum.reduce(assigns[:transactions], 0,fn (transaction, acc) -> transaction.amount.amount + acc end) |> Money.new() %>
          </span></div>
      </div>
    """
  end
end
