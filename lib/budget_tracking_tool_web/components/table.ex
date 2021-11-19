defmodule BudgetTrackingToolWeb.Components.Table do
  use Phoenix.Component

  def sortable_header(
        %{label: label, property: property, order_direction: order_direction, order_field: order_field} = assigns
      ) do
    ~H"""
      <th phx-click="order_field" phx-value-property={property} scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider text-right hover:cursor-pointer hover:text-gray-700">
        <div class="flex items-center justify-end">
          <%= label %>
          <%= if order_field === property do %>
            <.sort order_direction={order_direction} />
          <% else %>
            <div class="ml-1 w-3"></div>
          <% end %>
        </div>
      </th>
    """
  end

  def sort(%{order_direction: :asc} = assigns) do
    ~H"""
    <svg class="h-3 w-3 ml-1" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 24 24">
      <path class="cls-2" d="M18.77,13.36a1,1,0,0,0-1.41-.13L13,16.86V5a1,1,0,0,0-2,0V16.86L6.64,13.23a1,1,0,1,0-1.28,1.54l6,5,.15.09.13.07a1,1,0,0,0,.72,0l.13-.07.15-.09,6-5A1,1,0,0,0,18.77,13.36Z"></path>
    </svg>
    """
  end

  def sort(%{order_direction: :desc} = assigns) do
    ~H"""
    <svg class="h-3 w-3 ml-1" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 24 24">
      <path  d="M5.23,10.64a1,1,0,0,0,1.41.13L11,7.14V19a1,1,0,0,0,2,0V7.14l4.36,3.63a1,1,0,1,0,1.28-1.54l-6-5-.15-.09-.13-.07a1,1,0,0,0-.72,0l-.13.07-.15.09-6,5A1,1,0,0,0,5.23,10.64Z"></path>
    </svg>
    """
  end

  def sort(%{order_direction: _order_direction} = assigns) do
    ~H"""
    <div class="ml-1 w-3"></div>
    """
  end
end
