defmodule BudgetTrackingToolWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `BudgetTrackingToolWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal BudgetTrackingToolWeb.TransactionLive.FormComponent,
        id: @transaction.id || :new,
        action: @live_action,
        transaction: @transaction,
        return_to: Routes.transaction_index_path(@socket, :index) %>
  """
  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(BudgetTrackingToolWeb.ModalComponent, modal_opts)
  end

  def live_slide_over(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    slide_over_opts = [id: :slide_over, return_to: path, component: component, opts: opts]
    live_component(BudgetTrackingToolWeb.Components.SlideOverComponent, slide_over_opts)
  end
end
