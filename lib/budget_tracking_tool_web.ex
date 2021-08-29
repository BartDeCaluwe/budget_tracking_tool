defmodule BudgetTrackingToolWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use BudgetTrackingToolWeb, :controller
      use BudgetTrackingToolWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: BudgetTrackingToolWeb

      import Plug.Conn
      import BudgetTrackingToolWeb.Gettext
      alias BudgetTrackingToolWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/budget_tracking_tool_web/templates",
        namespace: BudgetTrackingToolWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())

      alias BudgetTrackingToolWeb.ViewHelpers
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {BudgetTrackingToolWeb.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      alias BudgetTrackingToolWeb.FormHelpers

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import BudgetTrackingToolWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView and .heex helpers (live_render, live_patch, <.form>, etc)
      import Phoenix.LiveView.Helpers
      import BudgetTrackingToolWeb.LiveHelpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import BudgetTrackingToolWeb.ErrorHelpers
      import BudgetTrackingToolWeb.Gettext
      alias BudgetTrackingToolWeb.Router.Helpers, as: Routes

      def put_org_id_from_session(session) do
        user = BudgetTrackingTool.Accounts.get_user_by_session_token(Map.get(session, "user_token"))
        user_orgs = BudgetTrackingTool.Accounts.list_user_orgs(user)
        BudgetTrackingTool.Repo.put_org_id(Enum.at(user_orgs, 0))
      end
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
