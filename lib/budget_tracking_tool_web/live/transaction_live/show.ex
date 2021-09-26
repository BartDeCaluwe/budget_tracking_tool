defmodule BudgetTrackingToolWeb.TransactionLive.Show do
  use BudgetTrackingToolWeb, :live_view

  alias BudgetTrackingTool.Transactions
  alias BudgetTrackingTool.Categories

  @impl true
  def mount(_params, session, socket) do
    put_org_id_from_session(session)

    {:ok,
     socket
     |> PhoenixLiveSession.maybe_subscribe(session)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:transaction, Transactions.get_transaction!(id))
     |> assign(:categories, Categories.list_categories())}
  end

  defp page_title(:show), do: "Show Transaction"
  defp page_title(:edit), do: "Edit Transaction"
end
