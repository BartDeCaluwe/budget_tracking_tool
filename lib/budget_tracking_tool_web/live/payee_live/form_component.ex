defmodule BudgetTrackingToolWeb.PayeeLive.FormComponent do
  use BudgetTrackingToolWeb, :live_component

  alias BudgetTrackingTool.Payees

  @impl true
  def update(%{payee: payee} = assigns, socket) do
    changeset =
      Payees.change_payee(payee, %{
        org_id: BudgetTrackingTool.Repo.get_org_id()
      })

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"payee" => payee_params}, socket) do
    changeset =
      socket.assigns.payee
      |> Payees.change_payee(payee_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"payee" => payee_params}, socket) do
    save_payee(socket, socket.assigns.action, payee_params)
  end

  defp save_payee(socket, :edit, payee_params) do
    case Payees.update_payee(socket.assigns.payee, payee_params) do
      {:ok, _payee} ->
        {:noreply,
         socket
         |> put_flash(:info, "Payee updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_payee(socket, :new, payee_params) do
    case Payees.create_payee(payee_params) do
      {:ok, _payee} ->
        {:noreply,
         socket
         |> put_flash(:info, "Payee created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
