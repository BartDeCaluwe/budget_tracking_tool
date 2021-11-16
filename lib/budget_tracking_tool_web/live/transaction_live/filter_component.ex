defmodule BudgetTrackingToolWeb.TransactionLive.FilterComponent do
  use BudgetTrackingToolWeb, :live_component

  alias BudgetTrackingTool.Categories.Category

  @select_category %Category{
    id: 0,
    label: "Select category",
    is_income: nil
  }
  @default_min_amount nil
  @default_max_amount nil
  @default_description nil
  @default_show_claimable nil

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> add_default_filters()}
  end

  def render(assigns) do
    ~H"""
    <form phx-submit="save"
          phx-change="validate"
          phx-blur="validate"
          phx-target={@myself}
          class="sm:flex flex-col mb-3 justify-between">
      <div class="flex items-end space-x-4">
        <button type="button" phx-click="reset-filters" phx-target={@myself} class="inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
          Reset
        </button>
        <button type="submit" class="w-full inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
          <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 24 24">
            <path d="M13.9,22a1,1,0,0,1-.6-.2l-4-3.05a1,1,0,0,1-.39-.8V14.68L4.11,5.46A1,1,0,0,1,5,4H19a1,1,0,0,1,.86.49,1,1,0,0,1,0,1l-5,9.21V21a1,1,0,0,1-.55.9A1,1,0,0,1,13.9,22Zm-3-4.54,2,1.53V14.44A1,1,0,0,1,13,14l4.3-8H6.64l4.13,8a1,1,0,0,1,.11.46Z"></path>
          </svg>
          Filter
        </button>
      </div>
        <div>
          <label for="description" class="block text-sm font-medium text-gray-700 sm:mt-px sm:pt-2">
            Description
          </label>
          <div class="mt-1 sm:mt-0 sm:col-span-2">
            <input type="text"
                  name="description"
                  id="description"
                  placeholder="shopping"
                  value={@description}
                  class="block w-full shadow-sm focus:ring-green-500 focus:border-green-500 sm:text-sm border-gray-300 rounded-md">
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
                  value={@min_amount}
                  phx-debounce="blur"
                  placeholder={to_string(Money.new(0))}
                  class="font-mono block w-full shadow-sm focus:ring-green-500 focus:border-green-500 sm:text-sm border-gray-300 rounded-md">
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
                  value={@max_amount}
                  phx-debounce="blur"
                  placeholder={to_string(Money.new(0))}
                  class="font-mono block w-full shadow-sm focus:ring-green-500 focus:border-green-500 sm:text-sm border-gray-300 rounded-md">
          </div>
        </div>
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
                  type="button" class="relative whitespace-nowrap w-full bg-white border border-gray-300 rounded-md shadow-sm pl-3 pr-10 py-2 text-left cursor-default focus:outline-none focus:ring-1 focus:ring-green-500 focus:border-green-500 sm:text-sm" aria-haspopup="listbox" aria-expanded="true" aria-labelledby="listbox-label">
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
        <div class="grid">
          <label for="claimable" class="block text-sm font-medium text-gray-700 sm:mt-px sm:pt-2">
            Claimable
          </label>
          <div>
            <div class="flex items-center">
              <button phx-click="toggle-claimable" phx-target={@myself} type="button" class={"relative inline-flex flex-shrink-0 h-6 w-11 border-2 border-transparent rounded-full cursor-pointer transition-colors ease-in-out duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 #{if @show_claimable, do: "bg-green-600", else: "bg-gray-200"}"} role="switch" aria-checked="false" aria-labelledby="annual-billing-label">
                <!-- Enabled: "translate-x-5", Not Enabled: "translate-x-0" -->
                <span aria-hidden="true" class={"pointer-events-none inline-block h-5 w-5 rounded-full bg-white shadow transform ring-0 transition ease-in-out duration-200 #{if @show_claimable, do: "translate-x-5", else: "translate-x-0"}"}></span>
              </button>
            </div>
          </div>
        </div>
    </form>
    """
  end

  def add_default_filters(socket) do
    categories = add_select_category_option(socket.assigns.categories)

    socket
    |> assign(:categories, categories)
    |> assign(:max_amount, @default_max_amount)
    |> assign(:min_amount, @default_min_amount)
    |> assign(:description, @default_description)
    |> assign(:show_claimable, @default_show_claimable)
    |> assign(:selected_category, Enum.at(categories, 0))
  end

  def handle_event("select-category", %{"category_id" => category_id}, socket) do
    {:noreply,
     socket
     |> assign(:selected_category, find_category_by_id(socket.assigns.categories, category_id))}
  end

  def handle_event("reset-filters", _params, socket) do
    socket =
      socket
      |> add_default_filters()

    send_filter_event(%{}, socket)

    {:noreply, socket}
  end

  def handle_event("toggle-claimable", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_claimable, toggle_claimable(socket.assigns.show_claimable))}
  end

  def handle_event(
        "validate",
        %{"min-amount" => min_amount, "max-amount" => max_amount, "description" => description},
        socket
      ) do
    {:noreply,
     socket
     |> validate_amount(:min_amount, min_amount)
     |> validate_amount(:max_amount, max_amount)
     |> assign(:description, description)}
  end

  def handle_event(
        "save",
        params,
        socket
      ) do
    send_filter_event(params, socket)
    {:noreply, socket}
  end

  defp send_filter_event(
         params,
         socket
       ) do
    send(
      self(),
      {:filter_transactions,
       [
         min_amount: nillify_empty_string(params, "min-amount", @default_min_amount),
         max_amount: nillify_empty_string(params, "max-amount", @default_max_amount),
         description: nillify_empty_string(params, "description", @default_description),
         category: socket.assigns.selected_category,
         show_claimable: socket.assigns.show_claimable
       ]}
    )
  end

  defp nillify_empty_string(params, key, default) do
    case Map.get(params, key) do
      "" -> default
      nil -> default
      value -> value
    end
  end

  defp find_category_by_id(categories, category_id) do
    {id, _} = Integer.parse(category_id)
    Enum.find(categories, @select_category, fn c -> c.id == id end)
  end

  defp validate_amount(socket, key, amount) do
    case Money.parse(amount) do
      :error ->
        assign(socket, key, nil)

      {:ok, parsed} ->
        assign(socket, key, parsed)
    end
  end

  defp add_select_category_option([@select_category | _rest] = categories), do: categories
  defp add_select_category_option(categories), do: [@select_category | categories]

  defp toggle_claimable(nil), do: true
  defp toggle_claimable(true), do: false
  defp toggle_claimable(false), do: true
end
