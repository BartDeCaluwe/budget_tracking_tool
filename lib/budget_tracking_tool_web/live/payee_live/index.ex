defmodule BudgetTrackingToolWeb.PayeeLive.Index do
  use BudgetTrackingToolWeb, :live_view

  alias BudgetTrackingTool.Payees
  alias BudgetTrackingTool.Payees.Payee

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :payees, list_payees())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Payee")
    |> assign(:payee, Payees.get_payee!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Payee")
    |> assign(:payee, %Payee{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Payees")
    |> assign(:payee, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    payee = Payees.get_payee!(id)
    {:ok, _} = Payees.delete_payee(payee)

    {:noreply, assign(socket, :payees, list_payees())}
  end

  defp list_payees do
    Payees.list_payees()
  end
end
