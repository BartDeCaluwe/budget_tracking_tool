defmodule BudgetTrackingToolWeb.ServiceWorkerController do
  use BudgetTrackingToolWeb, :controller

  def service_worker(conn, _) do
    conn
    |> put_resp_content_type("application/javascript")
    |> render("service_worker.js")
  end
end
