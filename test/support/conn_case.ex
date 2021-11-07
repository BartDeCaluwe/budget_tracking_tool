defmodule BudgetTrackingToolWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use BudgetTrackingToolWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import BudgetTrackingToolWeb.ConnCase

      alias BudgetTrackingToolWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint BudgetTrackingToolWeb.Endpoint
    end
  end

  setup tags do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(BudgetTrackingTool.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Setup helper that registers and logs in users.

      setup :register_and_log_in_user

  It stores an updated connection and a registered user in the
  test context.
  """
  def register_and_log_in_user(%{conn: conn}) do
    user = BudgetTrackingTool.AccountsFixtures.user_fixture()
    %{conn: conn, org_id: org_id} = log_in_user(conn, user)

    %{conn: conn, user: user, org_id: org_id}
  end

  @doc """
  Logs the given `user` into the `conn`.

  It returns an updated `conn`.
  """
  def log_in_user(conn, user) do
    token = BudgetTrackingTool.Accounts.generate_user_session_token(user)
    %{org_id: org_id} = create_and_set_org()

    conn =
      conn
      |> Phoenix.ConnTest.init_test_session(%{})
      |> Plug.Conn.put_session(:user_token, token)
      |> Plug.Conn.put_session(:org_id, org_id)

    %{conn: conn, org_id: org_id}
  end

  def create_and_set_org() do
    org = BudgetTrackingTool.OrgsFixtures.org_fixture()
    BudgetTrackingTool.Repo.put_org_id(org.id)

    %{org_id: org.id}
  end
end
