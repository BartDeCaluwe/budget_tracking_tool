defmodule BudgetTrackingToolWeb.TransactionLive.FormComponent do
  use BudgetTrackingToolWeb, :live_component

  alias BudgetTrackingTool.Transactions
  alias BudgetTrackingTool.Payees

  @impl true
  def update(%{transaction: transaction} = assigns, socket) do
    changeset = Transactions.change_transaction(transaction)
    selected_category = transaction.category || Enum.at(assigns.categories, 0)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(
       :selected_category,
       put_prefix_color(selected_category)
     )
     |> assign(:selected_payee, transaction.payee)}
  end

  defp prefix_color(true), do: "bg-green-400"
  defp prefix_color(false), do: "bg-red-400"

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

  def handle_event("select-payee", %{"option_id" => payee_id}, socket) do
    case find_payee_by_id(socket.assigns.payees, payee_id) do
      nil ->
        changeset =
          Transactions.put_change(
            socket.assigns.changeset,
            :payee_id,
            nil
          )

        {:noreply,
         socket
         |> assign(:changeset, changeset)
         |> assign(:selected_payee, Enum.at(socket.assigns.payees, 0))}

      payee ->
        changeset =
          Transactions.put_change(
            socket.assigns.changeset,
            :payee_id,
            payee.id
          )

        {:noreply,
         socket
         |> assign(:changeset, changeset)
         |> assign(:selected_payee, payee)}
    end
  end

  def handle_event("select-category", %{"option_id" => category_id}, socket) do
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
     |> assign(
       :selected_category,
       put_prefix_color(selected_category)
     )}
  end

  defp put_prefix_color(category) do
    Map.put(
      category,
      :prefix_color,
      prefix_color(category.is_income)
    )
  end

  def handle_event("add-option", %{"label" => name}, socket) do
    new_payee = %{
      name: name,
      org_id: BudgetTrackingTool.Repo.get_org_id()
    }

    {:ok, payee} = Payees.create_payee(new_payee)

    changeset =
      Transactions.put_change(
        socket.assigns.changeset,
        :payee_id,
        payee.id
      )

    {:noreply,
     socket
     |> assign(:payees, [payee | socket.assigns.payees])
     |> assign(:changeset, changeset)
     |> assign(:selected_payee, payee)}
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

  defp find_payee_by_id(_payees, "0"), do: nil

  defp find_payee_by_id(payees, payee_id) do
    {id, _} = Integer.parse(payee_id)
    Enum.find(payees, fn p -> p.id == id end)
  end
end
