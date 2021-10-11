defmodule BudgetTrackingToolWeb.TransactionLive.FilterComponent do
  use BudgetTrackingToolWeb, :live_component

  def render(assigns) do
    ~H"""
    <form phx-submit="save" phx-target={@myself} class="flex justify-between mb-3">
      <div class="flex space-x-2">
      <div>
        <label for="description" class="block text-sm font-medium text-gray-700 sm:mt-px sm:pt-2">
          Description
        </label>
        <div class="mt-1 sm:mt-0 sm:col-span-2">
          <input type="text"
                 name="description"
                 id="description"
                 placeholder="shopping"
                 class="max-w-lg block w-full shadow-sm focus:ring-green-500 focus:border-green-500 sm:max-w-xs sm:text-sm border-gray-300 rounded-md">
        </div>
      </div>
      <div>
        <label for="min-amount" class="block text-sm font-medium text-gray-700 sm:mt-px sm:pt-2">
          Min amount
        </label>
        <div class="mt-1 sm:mt-0 sm:col-span-2">
          <input type="text"
                 name="min-amount"
                 id="min-amount"
                 placeholder={to_string(Money.new(0))}
                 class="max-w-lg block w-full shadow-sm focus:ring-green-500 focus:border-green-500 sm:max-w-xs sm:text-sm border-gray-300 rounded-md">
        </div>
      </div>
      <div>
        <label for="max-amount" class="block text-sm font-medium text-gray-700 sm:mt-px sm:pt-2">
          Max amount
        </label>
        <div class="mt-1 sm:mt-0 sm:col-span-2">
          <input type="text"
                 name="max-amount"
                 id="max-amount"
                 placeholder={to_string(Money.new(0))}
                 class="max-w-lg block w-full shadow-sm focus:ring-green-500 focus:border-green-500 sm:max-w-xs sm:text-sm border-gray-300 rounded-md">
        </div>
      </div>
      </div>
      <div class="flex items-end">
        <button type="submit" class="ml-3 inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
          <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 24 24">
            <path d="M13.9,22a1,1,0,0,1-.6-.2l-4-3.05a1,1,0,0,1-.39-.8V14.68L4.11,5.46A1,1,0,0,1,5,4H19a1,1,0,0,1,.86.49,1,1,0,0,1,0,1l-5,9.21V21a1,1,0,0,1-.55.9A1,1,0,0,1,13.9,22Zm-3-4.54,2,1.53V14.44A1,1,0,0,1,13,14l4.3-8H6.64l4.13,8a1,1,0,0,1,.11.46Z"></path>
          </svg>
          Filter
        </button>
      </div>
    </form>
    """
  end

  def handle_event(
        "save",
        %{"min-amount" => min_amount, "max-amount" => max_amount, "description" => description},
        socket
      ) do
    send(
      self(),
      {:filter_transactions,
       [
         min_amount: min_amount,
         max_amount: max_amount,
         description: description
       ]}
    )

    {:noreply, socket}
  end
end
