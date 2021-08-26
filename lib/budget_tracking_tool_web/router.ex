defmodule BudgetTrackingToolWeb.Router do
  use BudgetTrackingToolWeb, :router

  import BudgetTrackingToolWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {BudgetTrackingToolWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BudgetTrackingToolWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/", BookLive.Show, :show
    get "/up", PageController, :up

    live "/budgets", BudgetLive.Index, :index
    live "/budgets/new", BudgetLive.Index, :new
    live "/budgets/:id/edit", BudgetLive.Index, :edit

    live "/budgets/:id", BudgetLive.Show, :show
    live "/budgets/:id/show/edit", BudgetLive.Show, :edit

    live "/books", BookLive.Index, :index
    live "/books/new", BookLive.Index, :new
    live "/books/:id/edit", BookLive.Index, :edit

    live "/books/:id", BookLive.Show, :show
    live "/books/:id/show/edit", BookLive.Show, :edit

    live "/categories", CategoryLive.Index, :index
    live "/categories/new", CategoryLive.Index, :new
    live "/categories/:id/edit", CategoryLive.Index, :edit

    live "/categories/:id", CategoryLive.Show, :show
    live "/categories/:id/show/edit", CategoryLive.Show, :edit

    live "/transactions", TransactionLive.Index, :index
    live "/transactions/new", TransactionLive.Index, :new
    live "/transactions/:id/edit", TransactionLive.Index, :edit

    live "/transactions/:id", TransactionLive.Show, :show
    live "/transactions/:id/show/edit", TransactionLive.Show, :edit
  end

  # Enables LiveDashboard only for development.
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: BudgetTrackingToolWeb.Telemetry
    end
  end

  ## Authentication routes

  scope "/", BudgetTrackingToolWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", BudgetTrackingToolWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update

    get "/users/settings/confirm_email/:token",
        UserSettingsController,
        :confirm_email
  end

  scope "/", BudgetTrackingToolWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end
end
