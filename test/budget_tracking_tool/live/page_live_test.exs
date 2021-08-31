defmodule BudgetTrackingToolWeb.PageLiveTest do
  use BudgetTrackingToolWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    conn = get(conn, "/")
    html_response(conn, 302)
  end
end
