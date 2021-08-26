defmodule BudgetTrackingToolWeb.BudgetLive.Index do
  use BudgetTrackingToolWeb, :live_view

  alias BudgetTrackingTool.Budgets
  alias BudgetTrackingTool.Budgets.Budget

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :budgets, list_budgets())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Budget")
    |> assign(:budget, Budgets.get_budget!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Budget")
    |> assign(:budget, %Budget{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Budgets")
    |> assign(:budget, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    budget = Budgets.get_budget!(id)
    {:ok, _} = Budgets.delete_budget(budget)

    {:noreply, assign(socket, :budgets, list_budgets())}
  end

  defp list_budgets do
    Budgets.list_budgets()
  end
end
