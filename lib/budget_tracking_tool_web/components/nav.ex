defmodule BudgetTrackingToolWeb.Components.Nav do
  use Phoenix.Component
  use Phoenix.HTML

  alias BudgetTrackingToolWeb.Router.Helpers, as: Routes

  @default_mobile_route_classes "block pl-3 pr-4 py-2 border-l-4 text-base font-medium"
  @default_route_classes "inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium"

  def render(assigns) do
    ~H"""
    <nav x-data="{ mobileMenuOpen: false, userMenuOpen: false, notificationMenuOpen: false }" class="bg-white shadow-sm">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
          <div class="flex">
            <div class="hidden sm:-my-px sm:flex sm:space-x-8">
              <%= if @current_user do %>
                <%= route(@conn, "/app", "Dashboard") %>
                <%= route(@conn, Routes.transaction_index_path(@conn, :index), "Transactions") %>
                <%= route(@conn, Routes.category_index_path(@conn, :index), "Categories") %>
                <%= route(@conn, Routes.book_index_path(@conn, :index), "Books") %>
                <%= route(@conn, Routes.payee_index_path(@conn, :index), "Payees") %>
              <% end %>
            </div>
          </div>
          <%= if @current_user do %>
            <div class="hidden sm:ml-6 sm:flex sm:items-center">
              <div class="relative ">
                <div class="flex items-center">
                  <button @click="notificationMenuOpen = !notificationMenuOpen" @click.outside="notificationMenuOpen = false" class="bg-white p-1 rounded-full text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
                    <span class="sr-only">View notifications</span>
                    <!-- Heroicon name: outline/bell -->
                    <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
                    </svg>
                    <%= if Enum.count(@notifications) > 0 do %>
                      <span class="flex h-2 w-2 absolute right-0.5 top-0.5">
                        <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-green-400 opacity-75"></span>
                        <span class="relative inline-flex rounded-full h-2 w-2 bg-green-500"></span>
                      </span>
                    <% end %>
                  </button>
                </div>
                <div x-cloak
                    x-show="notificationMenuOpen"
                    class="origin-top-right absolute right-0 mt-2 rounded-md shadow-lg py-2 bg-white ring-1 ring-black ring-opacity-5 focus:outline-none z-10">
                  <%= if Enum.count(@notifications) > 0 do %>
                  <div class="flow-root mt-6">
                    <ul role="list" class="-my-5 divide-y divide-gray-200">
                      <%= for invite <- Enum.slice(@notifications, 0..4) do %>
                      <li class="py-4 px-2 flex justify-between">
                        <div class="flex items-center space-x-4">
                          <div class="flex-1 min-w-0">
                            <p class="text-sm font-medium text-gray-900 truncate">
                              <%= invite.org.name %>
                            </p>
                             <p class="text-sm text-gray-500 truncate">
                              <%= invite.user.email %>
                            </p>
                          </div>
                        </div>
                        <div class="ml-3 flex space-x-1">
                          <%= link "Reject", to:  Routes.org_invite_url(@conn, :reject, invite.id), class: "inline-flex items-center shadow-sm px-2.5 py-0.5 border border-gray-300 text-sm leading-5 font-medium rounded-full text-gray-700 bg-white hover:bg-gray-50" %>
                          <%= link "Accept", to:  Routes.org_invite_url(@conn, :accept, invite.id), class: "inline-flex items-center shadow-sm px-2.5 py-0.5 border border-gray-300 text-sm leading-5 font-medium rounded-full text-gray-700 bg-white hover:bg-gray-50" %>
                        </div>
                      </li>
                      <% end %>
                    </ul>
                 </div>
                  <div class="mt-6 px-2">
                    <a href="#" class="w-full flex justify-center items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                      View all (<%= Enum.count(@notifications) %>)
                    </a>
                  </div>
                  <% else %>
                    <div class="mx-3 whitespace-nowrap text-gray-600">No notifications</div>
                  <% end %>
                </div>
              </div>

              <!-- Profile dropdown -->
              <div class="ml-3 relative">
                <div>
                  <button @click="userMenuOpen = !userMenuOpen" @click.outside="userMenuOpen = false" type="button" class="bg-white flex text-sm rounded-full focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500" id="user-menu-button" aria-expanded="false" aria-haspopup="true">
                    <span class="sr-only">Open user menu</span>
                    <img class="h-8 w-8 rounded-full" src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
                  </button>
                </div>
                <div
                  x-transition:enter="transition ease-out duration-100"
                  x-transition:enter-start="transform opacity-0 scale-95"
                  x-transition:enter-end="transform opacity-100 scale-100"
                  x-transition:leave="transition ease-in duration-75"
                  x-transition:leave-start="transform opacity-100 scale-100"
                  x-transition:leave-end="transform opacity-0 scale-95"
                  x-show="userMenuOpen"
                  x-cloak
                  class="origin-top-right absolute right-0 mt-2 w-48 rounded-md shadow-lg py-1 bg-white ring-1 ring-black ring-opacity-5 focus:outline-none z-10" role="menu" aria-orientation="vertical" aria-labelledby="user-menu-button" tabindex="-1">
                    <%= link "Settings", to: Routes.user_settings_path(@conn, :edit),  class: "hover:bg-gray-100 block px-4 py-2 text-sm text-gray-700", role: "menuitem", tabindex: "-1" %>
                    <%= link "Sign out", to: Routes.user_session_path(@conn, :delete), method: :delete,  class: "hover:bg-gray-100 block px-4 py-2 text-sm text-gray-700", role: "menuitem", tabindex: "-1" %>
                </div>
              </div>
            </div>
          <% else %>
            <div class="flex items-center space-x-4">
              <%= route(@conn, Routes.user_registration_path(@conn, :new), "Register") %>
              <%= route(@conn, Routes.user_session_path(@conn, :new), "Login") %>
            </div>
          <% end %>
          <div class="-mr-2 flex items-center sm:hidden">
            <!-- Mobile menu button -->
            <button @click="mobileMenuOpen = !mobileMenuOpen" @click.outside="mobileMenuOpen = false" type="button" class="bg-white inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500" aria-controls="mobile-menu" aria-expanded="false">
              <span class="sr-only">Open main menu</span>
              <svg class="h-6 w-6" :class="mobileMenuOpen ? 'hidden' : 'block'" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
              </svg>
              <svg class="h-6 w-6" :class="mobileMenuOpen ? 'block' : 'hidden'" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
        </div>
      </div>

      <!-- Mobile menu, show/hide based on menu state. -->
      <div x-cloak x-show="mobileMenuOpen" class="sm:hidden" id="mobile-menu">
        <div class="pt-2 pb-3 space-y-1">
          <%= if @current_user do %>
            <%= mobile_route(@conn, "/app", "Dashboard") %>
            <%= mobile_route(@conn, Routes.transaction_index_path(@conn, :index), "Transactions") %>
            <%= mobile_route(@conn, Routes.category_index_path(@conn, :index), "Categories") %>
            <%= mobile_route(@conn, Routes.book_index_path(@conn, :index), "Books") %>
            <%= mobile_route(@conn, Routes.payee_index_path(@conn, :index), "Payees") %>
          <% end %>
        </div>
        <div class="pt-4 pb-3 border-t border-gray-200">
          <div class="flex items-center px-4">
            <div class="flex-shrink-0">
              <img class="h-10 w-10 rounded-full" src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
            </div>
            <div class="ml-3">
              <div class="text-base font-medium text-gray-800">Tom Cook</div>
              <div class="text-sm font-medium text-gray-500">tom@example.com</div>
            </div>
            <button class="ml-auto bg-white flex-shrink-0 p-1 rounded-full text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
              <span class="sr-only">View notifications</span>
              <!-- Heroicon name: outline/bell -->
              <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
              </svg>
            </button>
          </div>
          <div class="mt-3 space-y-1">
            <%= link "Settings", to: Routes.user_settings_path(@conn, :edit),  class: "block px-4 py-2 text-base font-medium text-gray-500 hover:text-gray-800 hover:bg-gray-100", role: "menuitem", tabindex: "-1" %>
            <%= link "Sign out", to: Routes.user_session_path(@conn, :delete), method: :delete,  class: "block px-4 py-2 text-base font-medium text-gray-500 hover:text-gray-800 hover:bg-gray-100", role: "menuitem", tabindex: "-1" %>
          </div>
        </div>
      </div>
    </nav>
    """
  end

  def route(conn, path, label) do
    link(label, to: path, class: get_route_classes(is_active_route(conn, path)))
  end

  def mobile_route(conn, path, label) do
    link(label,
      to: path,
      class: get_mobile_route_classes(is_active_route(conn, path))
    )
  end

  defp is_active_route(conn, path) do
    current_path = Path.join(["/" | conn.path_info])
    path == current_path
  end

  defp get_route_classes(true), do: "border-green-500 text-gray-900 #{@default_route_classes}"
  defp get_route_classes(false), do: "border-transparent text-gray-500 #{@default_route_classes}"

  defp get_mobile_route_classes(true),
    do: "bg-green-50 border-green-500 text-green-700 #{@default_mobile_route_classes}"

  defp get_mobile_route_classes(false),
    do:
      "border-transparent text-gray-600 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-800 #{@default_mobile_route_classes}"
end
