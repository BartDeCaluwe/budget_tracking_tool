defmodule BudgetTrackingToolWeb.UserRegistrationController do
  use BudgetTrackingToolWeb, :controller

  alias BudgetTrackingTool.Accounts
  alias BudgetTrackingTool.Accounts.{User, Org}
  alias BudgetTrackingTool.Books
  alias BudgetTrackingTool.Categories
  alias BudgetTrackingToolWeb.UserAuth

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{orgs: [%Org{}]})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        %{id: _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :confirm, &1)
          )

        {:ok, _book} = Books.create_default_book(user)
        Categories.create_default_categories(user)

        conn
        |> put_flash(:info, "User created successfully.")
        |> put_session(:user_return_to, Routes.book_show_path(conn, :show))
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
