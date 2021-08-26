defmodule BudgetTrackingToolWeb.BudgetLive.FormComponent do
  use BudgetTrackingToolWeb, :live_component

  alias BudgetTrackingTool.Budgets

  @impl true
  def update(%{budget: budget} = assigns, socket) do
    changeset = Budgets.change_budget(budget)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"budget" => budget_params}, socket) do
    socket.assigns.budget
      |> Budgets.change_budget(budget_params)
      |> Map.put(:action, :validate)

    case Budgets.change_budget(socket.assigns.budget, budget_params) do
      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, Map.put(changeset, :action, :validate))}

      _changeset ->
        handle_event("save", %{"budget" => budget_params}, socket)
    end
  end

  def handle_event("save", %{"budget" => budget_params}, socket) do
    save_budget(socket, socket.assigns.action, budget_params)
  end

  defp save_budget(socket, :edit, budget_params) do
    case Budgets.update_budget(socket.assigns.budget, budget_params) do
      {:ok, _budget} ->
        {:noreply,
         socket
         |> put_flash(:info, "Budget updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_budget(socket, :new, budget_params) do
    case Budgets.create_budget(budget_params) do
      {:ok, _budget} ->
        {:noreply,
         socket
         |> put_flash(:info, "Budget created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
