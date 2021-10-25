defmodule BudgetTrackingToolWeb.ViewHelpers do
  @moduledoc """
  Convenience functions for your templates.
  """
  use BudgetTrackingToolWeb, :view

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
