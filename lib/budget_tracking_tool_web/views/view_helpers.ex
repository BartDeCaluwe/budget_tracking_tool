defmodule BudgetTrackingToolWeb.ViewHelpers do
  @moduledoc """
  Convenience functions for your templates.
  """
  use BudgetTrackingToolWeb, :view

  @default_mobile_route_classes "block pl-3 pr-4 py-2 border-l-4 text-base font-medium"
  @default_route_classes "inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium"

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

  def route(conn, path, label) do
    link(label, to: path, class: get_route_classes(is_active_route(conn, path)))
  end

  def mobile_route(conn, path, label) do
    link(label,
      to: path,
      class: get_mobile_route_classes(is_active_route(conn, path))
    )
  end

  defp is_active_route(conn, path) do
    current_path = Path.join(["/" | conn.path_info])
    path == current_path
  end

  defp get_route_classes(true), do: "border-indigo-500 text-gray-900 #{@default_route_classes}"
  defp get_route_classes(false), do: "border-transparent text-gray-500 #{@default_route_classes}"

  defp get_mobile_route_classes(true),
    do: "bg-indigo-50 border-indigo-500 text-indigo-700 #{@default_mobile_route_classes}"

  defp get_mobile_route_classes(false),
    do:
      "border-transparent text-gray-600 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-800 #{@default_mobile_route_classes}"
end
