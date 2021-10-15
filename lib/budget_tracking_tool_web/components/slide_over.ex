defmodule BudgetTrackingToolWeb.Components.SlideOverComponent do
  use BudgetTrackingToolWeb, :live_component

  @impl true
  def render(assigns) do
    assigns =
      assign(
        assigns,
        :opts,
        assigns.opts ++
          [
            slide_over: true,
            form_id: "slide-over-form",
            form: true
          ]
      )

    ~H"""
    <div id={@id}
      phx-capture-click="close"
      phx-window-keydown="close"
      phx-key="escape"
      phx-target={"##{@id}"}
      phx-page-loading
      class="fixed inset-0 overflow-hidden z-10" aria-labelledby="slide-over-title" role="dialog" aria-modal="true">
      <div class="absolute inset-0 overflow-hidden">
        <!-- Background overlay, show/hide based on slide-over state. -->
        <div class="absolute inset-0" aria-hidden="true">
          <div class="fixed inset-y-0 right-0 pl-10 max-w-full flex">
            <!--
              Slide-over panel, show/hide based on slide-over state.

              Entering: "transform transition ease-in-out duration-500 sm:duration-700"
                From: "translate-x-full"
                To: "translate-x-0"
              Leaving: "transform transition ease-in-out duration-500 sm:duration-700"
                From: "translate-x-0"
                To: "translate-x-full"
            -->
            <div class="w-screen max-w-md">
              <div class="h-full divide-y divide-gray-200 flex flex-col bg-white shadow-xl">
                <div class="min-h-0 flex-1 flex flex-col py-6 overflow-y-scroll">
                  <div class="px-4 sm:px-6">
                    <div class="flex items-start justify-between">
                      <h2 class="text-lg font-medium text-gray-900" id="slide-over-title">
                        <%= @opts[:title] %>
                      </h2>
                      <div class="ml-3 h-7 flex items-center">
                        <button type="button" class="bg-white rounded-md text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-green-500">
                          <%= live_patch  to: @return_to, class: "phx-modal-close bg-white rounded-md text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500" do %>
                            <span class="sr-only">Close</span>
                            <!-- Heroicon name: outline/x -->
                            <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                            </svg>
                          <% end %>
                        </button>
                      </div>
                    </div>
                  </div>
                  <div class="mt-6 relative flex-1 px-4 sm:px-6">
                    <!-- Replace with your content -->
                    <div class="mt-3 text-center sm:mt-0 sm:text-left">
                      <%= live_component @socket, @component, @opts %>
                    </div>
                    <!-- /End replace -->
                  </div>
                </div>
                <div class="flex-shrink-0 px-4 py-4 flex justify-end">
                  <%= if @opts[:form] do %>
                  <button phx-click="close" phx-target={@myself} type="button" class="bg-white py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
                    Cancel
                  </button>
                  <button form="slide-over-form" type="submit" class="ml-4 inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
                    Save
                  </button>
                  <% end %>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
