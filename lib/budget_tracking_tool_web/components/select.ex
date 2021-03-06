defmodule BudgetTrackingToolWeb.Components.Select do
  use BudgetTrackingToolWeb, :live_component
  alias Phoenix.LiveView.JS

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:has_prefix, assigns[:has_prefix] || false)
     |> assign_changeset(assigns.selected_option)
     |> assign(:options, normalize_options(assigns.options))
     |> assign(:filtered_options, normalize_options(assigns.options))
     |> assign(:selected_option, normalize_option(assigns.selected_option))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="select-wrapper" phx-click-away={JS.hide(to: get_wrapper_id_selector(@id))}>
      <.form let={f}
             as="select-form"
             for={@changeset}
             id="select-form"
             phx-target={@myself}
             phx-change="validate">
          <div
            class="mt-1 relative"
            >
              <button
                phx-click={JS.toggle(to: get_wrapper_id_selector(@id)) |> JS.dispatch("focus", to: get_query_input_id_selector(@id))}
                id="select-list-button"
                type="button" class="relative w-full bg-white border border-gray-300 rounded-md shadow-sm pl-3 pr-10 py-2 text-left cursor-default focus:outline-none focus:ring-1 focus:ring-green-500 focus:border-green-500 sm:text-sm" aria-haspopup="listbox" aria-expanded="true" aria-labelledby="listbox-label">
                <div class="flex items-center">
                  <%= if @selected_option.id do %>
                    <.select_label option={@selected_option} has_prefix={@has_prefix} />
                  <% else %>
                    <span class="block truncate text-gray-500">
                      <%= @placeholder %>
                    </span>
                  <% end %>
                </div>
                <span class="absolute inset-y-0 right-0 flex items-center pr-2 pointer-events-none">
                  <!-- Heroicon name: solid/selector -->
                  <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                    <path fill-rule="evenodd" d="M10 3a1 1 0 01.707.293l3 3a1 1 0 01-1.414 1.414L10 5.414 7.707 7.707a1 1 0 01-1.414-1.414l3-3A1 1 0 0110 3zm-3.707 9.293a1 1 0 011.414 0L10 14.586l2.293-2.293a1 1 0 011.414 1.414l-3 3a1 1 0 01-1.414 0l-3-3a1 1 0 010-1.414z" clip-rule="evenodd" />
                  </svg>
                </span>
              </button>
            <div id={get_wrapper_id(@id)} class="hidden absolute z-10 mt-1">
              <%= text_input f, :query, id: get_query_input_id(@id), type: "text", placeholder: "search or create" %>
              <ul
                class="mt-1 w-full bg-white shadow-lg max-h-60 rounded-md text-base ring-1 ring-black ring-opacity-5 overflow-auto focus:outline-none sm:text-sm"
                role="tablist"
                aria-labelledby="listbox-label"
                id="select-list"
                aria-activedescendant="listbox-option-3"
                >
                <%= for {option, index} <- Enum.with_index(@filtered_options) do %>
                <li
                  phx-click={handle_select(@target, @id, @handle_select, option.label, option.id)}
                  class="group hover:text-white hover:bg-green-600 focus:text-white focus:bg-green-600 focus:outline-none text-gray-900 cursor-default select-none relative py-2 pl-3 pr-9"
                  id={"listbox-option-#{index}"}
                  tabindex={index}
                  role="tab">
                  <div class="flex items-center">
                    <.select_label option={option} has_prefix={@has_prefix}/>
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
                <%= if @allow_add and Ecto.Changeset.get_change(@changeset, :query) do %>
                  <li
                    id="add-option-button"
                    class="group hover:text-white hover:bg-green-600 focus:text-white focus:bg-green-600 focus:outline-none text-gray-900 cursor-default select-none relative py-2 pl-3 pr-9"
                    phx-click={handle_add_option(@target, @id, @changeset.changes.query)}
                  >
                    <div class="flex items-center">
                      <span class="font-semibold block truncate">
                        Add <%= @changeset.changes.query  %>
                      </span>
                    </div>
                  </li>
                <% end %>
              </ul>
            </div>
          </div>
        </.form>
      </div>
    """
  end

  def get_wrapper_id(id), do: "#{id}-wrapper"
  def get_wrapper_id_selector(id), do: "##{get_wrapper_id(id)}"
  def get_query_input_id(id), do: "#{id}-query"
  def get_query_input_id_selector(id), do: "##{get_query_input_id(id)}"

  def handle_add_option(target, id, label) do
    %JS{}
    |> JS.hide(to: get_wrapper_id_selector(id))
    |> JS.push("add-option", target: target, value: %{label: label})
  end

  def handle_select(target, id, event, label, option_id) do
    %JS{}
    |> JS.hide(to: get_wrapper_id_selector(id))
    |> JS.push(event, target: target, value: %{option_label: label, option_id: to_string(option_id)})
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

  def select_label(assigns) do
    ~H"""
      <div class="flex items-center">
        <span class={"#{Map.get(@option, :prefix_color, "hidden")} mr-3 flex-shrink-0 inline-block h-2 w-2 rounded-full"} aria-hidden="true"></span>
        <span>
          <%= @option.label %>
        </span>
      </div>
    """
  end

  defp normalize_options(options) do
    Enum.map(options, &normalize_option/1)
  end

  defp normalize_option(nil), do: %{label: "", id: nil}
  defp normalize_option(%{label: _label, id: _id} = option), do: option

  defp normalize_option(%{name: name} = option) do
    Map.put(option, :label, name)
  end

  defp normalize_option(_option), do: raise("Cannot normalize option")

  defp filter_options(options, query) do
    query = String.downcase(query)

    options
    |> Enum.filter(fn option -> String.downcase(option.label) |> String.contains?(query) end)
  end
end
