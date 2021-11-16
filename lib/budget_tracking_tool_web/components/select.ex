defmodule BudgetTrackingToolWeb.Components.Select do
  use BudgetTrackingToolWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_changeset(assigns.selected_option)
     |> assign(:options, normalize_options(assigns.options))
     |> assign(:filtered_options, normalize_options(assigns.options))
     |> assign(:selected_option, normalize_option(assigns.selected_option))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.form let={f}
             as="select-form"
             for={@changeset}
             id="select-form"
             phx-target={@myself}
             phx-change="validate">
          <div
            class="mt-1 relative"
            x-data="{open: false}"
            @click.outside="open = false"
            @click.inside="open = true">
            <%= text_input f, :query, type: "text", placeholder: "payee" %>
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
              <%= for {option, index} <- Enum.with_index(@filtered_options) do %>
                <li
                  @click="open = false"
                  phx-click="select-option"
                  phx-value-option_label={option.label}
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
              <%= if Map.get(@changeset.changes, :query) do %>
                <li
                  class="group hover:text-white hover:bg-green-600 focus:text-white focus:bg-green-600 focus:outline-none text-gray-900 cursor-default select-none relative py-2 pl-3 pr-9"
                  phx-click="add-option"
                  phx-value-label={@changeset.changes.query}
                  phx-target={@target}
                >
                  <div class="flex items-center">
                    <span class="font-semibold block truncate">
                      Add <%= @changeset.changes.query %>
                    </span>
                  </div>
                </li>
              <% end %>
            </ul>
          </div>
        </.form>
      </div>
    """
  end

  @impl true
  def handle_event("validate", %{"select-form" => %{"query" => query} = params}, socket) do
    data = %{}
    types = %{query: :string}

    changeset =
      {data, types}
      |> Ecto.Changeset.cast(params, Map.keys(types))
      |> Map.put(:action, :validate)

    filtered_options = filter_options(socket.assigns.options, query)

    {:noreply,
     socket
     |> assign(:changeset, changeset)
     |> assign(:filtered_options, filtered_options)}
  end

  def assign_changeset(socket, selected_option) do
    selected_option = normalize_option(selected_option)
    data = %{query: selected_option.label}
    types = %{query: :string}
    params = %{query: selected_option.label}

    changeset =
      {data, types}
      |> Ecto.Changeset.cast(params, Map.keys(types))

    socket
    |> assign(:changeset, changeset)
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

  defp normalize_option(nil), do: %{label: "", id: nil}
  defp normalize_option(%{label: _label, id: _id} = option), do: option

  defp normalize_option(%{name: name, id: id}) do
    %{label: name, id: id}
  end

  defp normalize_option(_option), do: raise("Cannot normalize option")

  defp filter_options(options, query) do
    query = String.downcase(query)

    options
    |> Enum.filter(fn option -> String.downcase(option.label) |> String.contains?(query) end)
  end
end
