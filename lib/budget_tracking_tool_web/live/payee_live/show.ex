defmodule BudgetTrackingToolWeb.PayeeLive.Show do
  use BudgetTrackingToolWeb, :live_view

  alias BudgetTrackingTool.Payees

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:payee, Payees.get_payee!(id))}
  end

  defp page_title(:show), do: "Show Payee"
  defp page_title(:edit), do: "Edit Payee"
end
