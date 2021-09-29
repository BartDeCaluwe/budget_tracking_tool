defmodule BudgetTrackingToolWeb.Components.EmptyState do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
      <div class="text-center">
        <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
          <path d="M19,5H5A3,3,0,0,0,2,8v8a3,3,0,0,0,3,3H19a3,3,0,0,0,3-3V8A3,3,0,0,0,19,5ZM4,8A1,1,0,0,1,5,7H19a1,1,0,0,1,1,1V9H4Zm16,8a1,1,0,0,1-1,1H5a1,1,0,0,1-1-1V11H20Z"></path>
          <path d="M7,15h4a1,1,0,0,0,0-2H7a1,1,0,0,0,0,2Z"></path>
          <path d="M15,15h2a1,1,0,0,0,0-2H15a1,1,0,0,0,0,2Z"></path>
        </svg>
        <h3 class="mt-2 text-sm font-medium text-gray-900"><%= @title %></h3>
        <p class="mt-1 text-sm text-gray-500">
          <%= @description %>
        </p>
        <div class="mt-6">
        <%= if assigns[:redirect_to] do %>
          <%= live_redirect to: @redirect_to do %>
            <button type="button" class="inline-flex items-center px-4 py-2 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
              <!-- Heroicon name: solid/plus -->
              <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z" clip-rule="evenodd" />
              </svg>
              <%= @button_text %>
            </button>
          <% end %>
        <% end %>
        <%= if assigns[:patch_to] do %>
          <%= live_patch to: @patch_to do %>
            <button type="button" class="inline-flex items-center px-4 py-2 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
              <!-- Heroicon name: solid/plus -->
              <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z" clip-rule="evenodd" />
              </svg>
              <%= @button_text %>
            </button>
          <% end %>
        <% end %>
        </div>
      </div>
    """
  end
end
