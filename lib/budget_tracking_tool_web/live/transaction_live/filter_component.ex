defmodule BudgetTrackingToolWeb.TransactionLive.FilterComponent do
  use BudgetTrackingToolWeb, :live_component

  alias BudgetTrackingTool.Categories.Category

  @select_category %Category{
    id: 0,
    label: "Select category",
    is_income: nil
  }

  def update(assigns, socket) do
    categories = [
      @select_category
      | assigns.categories
    ]

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:categories, categories)
     |> assign(:selected_category, Enum.at(categories, 0))}
  end

  def render(assigns) do
    ~H"""
    <form phx-submit="save" phx-target={@myself} class="flex justify-between mb-3">
      <div class="grid grid-cols-4 gap-2">
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
        <div>
        <div class="">
          <label for="category" class="block text-sm font-medium text-gray-700 sm:mt-px sm:pt-2">
            Category
          </label>
          <div class="">
            <div
              x-data="{open: false}"
              @click.outside="open = false"
            >
              <div
                class="sm:mt-0 mt-1 relative"
                >
                <button
                  @click="open = true"
                  @focus="open = true"
                  type="button" class="relative w-full bg-white border border-gray-300 rounded-md shadow-sm pl-3 pr-10 py-2 text-left cursor-default focus:outline-none focus:ring-1 focus:ring-green-500 focus:border-green-500 sm:text-sm" aria-haspopup="listbox" aria-expanded="true" aria-labelledby="listbox-label">
                  <div class="flex items-center">
                    <%= live_component BudgetTrackingToolWeb.CategoryLive.LabelComponent,
                      category: @selected_category
                    %>
                  </div>
                  <span class="absolute inset-y-0 right-0 flex items-center pr-2 pointer-events-none">
                    <!-- Heroicon name: solid/selector -->
                    <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                      <path fill-rule="evenodd" d="M10 3a1 1 0 01.707.293l3 3a1 1 0 01-1.414 1.414L10 5.414 7.707 7.707a1 1 0 01-1.414-1.414l3-3A1 1 0 0110 3zm-3.707 9.293a1 1 0 011.414 0L10 14.586l2.293-2.293a1 1 0 011.414 1.414l-3 3a1 1 0 01-1.414 0l-3-3a1 1 0 010-1.414z" clip-rule="evenodd" />
                    </svg>
                  </span>
                </button>

                <ul
                  x-cloak
                  x-show="open"
                  x-transition:enter=""
                  x-transition:enter-start=""
                  x-transition:enter-end=""
                  x-transition:leave="transition ease-in duration-100"
                  x-transition:leave-start="opacity-100"
                  x-transition:leave-end="opacity-0"
                  class="absolute z-10 mt-1 w-full bg-white shadow-lg max-h-60 rounded-md py-1 text-base ring-1 ring-black ring-opacity-5 overflow-auto focus:outline-none sm:text-sm"
                  role="tablist"
                  aria-labelledby="listbox-label"
                  aria-activedescendant="listbox-option-3"
                  >
                  <%= for {category, index} <- Enum.with_index(@categories) do %>
                    <li
                      @click="open = false"
                      phx-click="select-category"
                      phx-value-category_id={"#{category.id}"}
                      phx-target={@myself}
                      class="group hover:text-white hover:bg-green-600 focus:text-white focus:bg-green-600 focus:outline-none text-gray-900 cursor-default select-none relative py-2 pl-3 pr-9"
                      id={"listbox-option-#{index}"}
                      tabindex={if index > 0, do: -1, else: 0}
                      role="tab">
                      <div class="flex items-center">
                        <%= live_component BudgetTrackingToolWeb.CategoryLive.LabelComponent,
                          category: category,
                          selected: @selected_category.id == category.id
                        %>
                      </div>

                      <span class="absolute inset-y-0 right-0 flex items-center pr-4 text-green-600 group-hover:text-white">
                        <%= if @selected_category.id == category.id do %>
                          <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
                          </svg>
                        <% end %>
                      </span>
                    </li>
                  <% end %>
                </ul>
              </div>
            </div>
          </div>
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

  def handle_event("select-category", %{"category_id" => category_id}, socket) do
    {:noreply,
     socket
     |> assign(:selected_category, find_category_by_id(socket.assigns.categories, category_id))}
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
         description: description,
         category: socket.assigns.selected_category
       ]}
    )

    {:noreply, socket}
  end

  defp find_category_by_id(categories, category_id) do
    {id, _} = Integer.parse(category_id)
    Enum.find(categories, @select_category, fn c -> c.id == id end)
  end
end
