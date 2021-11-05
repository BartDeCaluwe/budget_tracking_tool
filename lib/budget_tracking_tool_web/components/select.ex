defmodule BudgetTrackingToolWeb.Components.Select do
  use BudgetTrackingToolWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:options, normalize_options(assigns.options))
     |> assign(:selected_option, normalize_option(assigns.selected_option))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div
          x-data="{open: false}"
          @click.outside="open = false"
        >
          <div
            class="mt-1 relative"
            >
            <button
              @click="open = true"
              @focus="open = true"
              type="button" class="relative w-full bg-white border border-gray-300 rounded-md shadow-sm pl-3 pr-10 py-2 text-left cursor-default focus:outline-none focus:ring-1 focus:ring-green-500 focus:border-green-500 sm:text-sm" aria-haspopup="listbox" aria-expanded="true" aria-labelledby="listbox-label">
              <div class="flex items-center">
                <.select_label option={@selected_option} />
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
              <%= for {option, index} <- Enum.with_index(@options) do %>
                <li
                  @click="open = false"
                  phx-click={@handle_select}
                  phx-value-option_id={option.id}
                  phx-target={@target}
                  class="group hover:text-white hover:bg-green-600 focus:text-white focus:bg-green-600 focus:outline-none text-gray-900 cursor-default select-none relative py-2 pl-3 pr-9"
                  id={"listbox-option-#{index}"}
                  tabindex={if index > 0, do: -1, else: 0}
                  role="tab">
                  <div class="flex items-center">
                    <.select_label option={option} />
                  </div>

                  <span class="absolute inset-y-0 right-0 flex items-center pr-4 text-green-600 group-hover:text-white">
                    <%= if @selected_option.id == option.id do %>
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
    """
  end

  def select_label(%{option: option, selected: _selected} = assigns) do
    ~H"""
      <div class="flex items-center">
        <span class="font-semibold block truncate">
          <%= option.label %>
        </span>
      </div>
    """
  end

  def select_label(%{option: option} = assigns) do
    ~H"""
      <div class="flex items-center">
        <span class=""><%= option.label %></span>
      </div>
    """
  end

  defp normalize_options(options) do
    Enum.map(options, &normalize_option/1)
  end

  defp normalize_option(%{label: _label, id: _id} = option), do: option

  defp normalize_option(%{name: name, id: id}) do
    %{label: name, id: id}
  end

  defp normalize_option(_option), do: raise("Cannot normalize option")
end
