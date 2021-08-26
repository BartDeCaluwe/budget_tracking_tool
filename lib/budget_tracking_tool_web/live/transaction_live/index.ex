defmodule BudgetTrackingToolWeb.TransactionLive.Index do
  use BudgetTrackingToolWeb, :live_view

  alias BudgetTrackingTool.Transactions
  alias BudgetTrackingTool.Transactions.Transaction
  alias BudgetTrackingTool.Categories

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:transactions, list_transactions())
     |> assign(:categories, list_categories())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Transaction")
    |> assign(:transaction, Transactions.get_transaction!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Transaction")
    |> assign(:transaction, %Transaction{
      date: DateTime.utc_now()
    })
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Transactions")
    |> assign(:transaction, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    transaction = Transactions.get_transaction!(id)
    {:ok, _} = Transactions.delete_transaction(transaction)

    {:noreply, assign(socket, :transactions, list_transactions())}
  end

  defp list_transactions do
    Transactions.list_transactions()
  end

  defp list_categories do
    Categories.list_categories()
  end
end
