defmodule BudgetTrackingToolWeb.TransactionLive.Index do
  use BudgetTrackingToolWeb, :live_view

  alias BudgetTrackingTool.Transactions
  alias BudgetTrackingTool.Transactions.Transaction
  alias BudgetTrackingTool.Categories
  alias BudgetTrackingTool.Payees.Payee
  alias BudgetTrackingTool.Payees

  @default_order_field "date"
  @default_order_direction :desc

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:filter, false)
     |> assign(:transactions, list_transactions(@default_order_field, @default_order_direction))
     |> assign(:categories, list_categories())
     |> assign(:payees, list_payees())
     |> assign(:order_field, @default_order_field)
     |> assign(:order_direction, @default_order_direction)}
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

  def handle_event("order_field", %{"property" => property}, socket) do
    order_direction = get_order_direction(socket.assigns.order_direction, socket.assigns.order_field, property)

    {:noreply,
     socket
     |> assign(:transactions, list_transactions(property, order_direction))
     |> assign(:order_field, property)
     |> assign(:order_direction, order_direction)}
  end

  @impl true
  def handle_info({:filter_transactions, filters}, socket) do
    {:noreply,
     socket
     |> assign(:filter, true)
     |> assign(
       :transactions,
       list_transactions(
         socket.assigns.order_field,
         socket.assigns.order_direction,
         filters
       )
     )}
  end

  def payee(nil), do: ""
  def payee(%Payee{name: name}), do: name

  defp list_transactions do
    Transactions.list_transactions()
  end

  defp list_transactions(order_field, order_direction) do
    Transactions.list_transactions(%{order_direction: order_direction, order_field: order_field})
  end

  defp list_transactions(order_field, order_direction, filters) do
    Transactions.list_transactions(
      %{order_direction: order_direction, order_field: order_field},
      filters
    )
  end

  defp list_categories do
    Enum.map(
      Categories.list_categories(),
      fn cat -> Map.put(cat, :prefix_color, prefix_color(cat.is_income)) end
    )
  end

  defp prefix_color(true), do: "bg-green-400"
  defp prefix_color(false), do: "bg-red-400"

  defp list_payees do
    Payees.list_payees()
  end

  defp get_order_direction(nil, nil, _property), do: :asc

  defp get_order_direction(:asc, order_field, property) do
    if order_field === property, do: :desc, else: :asc
  end

  defp get_order_direction(:desc, order_field, property) do
    if order_field === property, do: :asc, else: :desc
  end
end
