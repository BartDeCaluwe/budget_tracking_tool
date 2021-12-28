defmodule BudgetTrackingToolWeb.CategoryLive.FormComponent do
  use BudgetTrackingToolWeb, :live_component

  alias BudgetTrackingTool.Categories
  alias BudgetTrackingTool.Categories.Category

  @impl true
  def update(%{category: category} = assigns, socket) do
    changeset =
      Categories.change_category(category, %{
        org_id: BudgetTrackingTool.Repo.get_org_id()
      })

    overspent_behavior_options =
      Ecto.Enum.values(Category, :overspent_behavior)
      |> Enum.map(fn b -> [key: Category.humanize(b), value: b] end)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:overspent_behavior_options, overspent_behavior_options)}
  end

  @impl true
  def handle_event("validate", %{"category" => category_params}, socket) do
    changeset =
      socket.assigns.category
      |> Categories.change_category(category_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"category" => category_params}, socket) do
    save_category(socket, socket.assigns.action, category_params)
  end

  defp save_category(socket, :edit, category_params) do
    case Categories.update_category(socket.assigns.category, category_params) do
      {:ok, _category} ->
        {:noreply,
         socket
         |> put_flash(:info, "Category updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_category(socket, :new, category_params) do
    case Categories.create_category(category_params) do
      {:ok, _category} ->
        {:noreply,
         socket
         |> put_flash(:info, "Category created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
