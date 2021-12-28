defmodule BudgetTrackingToolWeb.ViewHelpers do
  @moduledoc """
  Convenience functions for your templates.
  """
  use BudgetTrackingToolWeb, :view

  def overspent_behaviour_label(behavior) do
    BudgetTrackingTool.Categories.Category.humanize(behavior)
  end

  def flash_class(type) do
    case type do
      "info" ->
        "blue"

      "success" ->
        "green"

      "warn" ->
        "yellow"

      "error" ->
        "red"

      _ ->
        "gray"
    end
  end
end
