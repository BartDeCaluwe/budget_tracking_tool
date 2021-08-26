defmodule BudgetTrackingToolWeb.BudgetLive.Show do
  use BudgetTrackingToolWeb, :live_view

  alias BudgetTrackingTool.Budgets

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:budget, Budgets.get_budget!(id))}
  end

  defp page_title(:show), do: "Show Budget"
  defp page_title(:edit), do: "Edit Budget"
end
