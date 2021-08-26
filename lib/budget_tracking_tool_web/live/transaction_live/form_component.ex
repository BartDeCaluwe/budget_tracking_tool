defmodule BudgetTrackingToolWeb.TransactionLive.FormComponent do
  use BudgetTrackingToolWeb, :live_component

  alias BudgetTrackingTool.Transactions

  @impl true
  def update(%{transaction: transaction} = assigns, socket) do
    changeset = Transactions.change_transaction(transaction)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:selected_category, Enum.at(assigns.categories, 0))}
  end

  @impl true
  def handle_event("validate", %{"transaction" => transaction_params}, socket) do
    changeset =
      socket.assigns.transaction
      |> Transactions.change_transaction(transaction_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:changeset, changeset)}
  end

  def handle_event("save", %{"transaction" => transaction_params}, socket) do
    save_transaction(socket, socket.assigns.action, transaction_params)
  end

  def handle_event("select-category", %{"category_id" => category_id}, socket) do
    selected_category = find_category_by_id(socket.assigns.categories, category_id)

    changeset =
      Transactions.put_change(
        socket.assigns.changeset,
        :category_id,
        selected_category.id
      )

    {:noreply,
     socket
     |> assign(:changeset, changeset)
     |> assign(:selected_category, selected_category)}
  end

  defp save_transaction(socket, :edit, transaction_params) do
    case Transactions.update_transaction(
           socket.assigns.transaction,
           transaction_params
         ) do
      {:ok, _transaction} ->
        {:noreply,
         socket
         |> put_flash(:info, "Transaction updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_transaction(socket, :new, transaction_params) do
    case Transactions.create_transaction(transaction_params) do
      {:ok, _transaction} ->
        {:noreply,
         socket
         |> put_flash(:info, "Transaction created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp find_category_by_id(categories, category_id) do
    {id, _} = Integer.parse(category_id)
    Enum.find(categories, fn c -> c.id == id end)
  end
end
