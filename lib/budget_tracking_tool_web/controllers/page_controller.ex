defmodule BudgetTrackingToolWeb.PageController do
  use BudgetTrackingToolWeb, :controller

  def home(conn, _params) do
    run_mode = if System.get_env("RELEASE_NAME"), do: "release", else: "mix"

    render(conn, "home.html",
      run_mode: run_mode,
      phoenix_ver: Application.spec(:phoenix, :vsn),
      elixir_ver: System.version()
    )
  end

  def up(conn, _params) do
    Ecto.Adapters.SQL.query!(BudgetTrackingTool.Repo, "SELECT 1")

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(:ok, "")
  end
end
