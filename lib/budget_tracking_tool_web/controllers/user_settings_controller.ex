defmodule BudgetTrackingToolWeb.UserSettingsController do
  use BudgetTrackingToolWeb, :controller

  alias BudgetTrackingTool.Accounts
  alias BudgetTrackingTool.Accounts.OrgInvite
  alias BudgetTrackingToolWeb.UserAuth

  plug :assign_settings_changesets

  def edit(conn, _params) do
    orgs =
      conn
      |> get_session(:user_token)
      |> Accounts.get_user_by_session_token()
      |> Accounts.list_orgs()

    case conn |> get_session(:org_id) do
      nil ->
        BudgetTrackingTool.Repo.put_org_id(Enum.at(orgs, 0).id)

        render(
          conn
          |> assign(:page_title, "Settings")
          |> assign(:session_org_id, BudgetTrackingTool.Repo.get_org_id())
          |> assign(:orgs, orgs),
          "edit.html"
        )

      id ->
        render(
          conn
          |> assign(:page_title, "Settings")
          |> assign(:session_org_id, id)
          |> assign(:orgs, orgs),
          "edit.html"
        )
    end
  end

  def invite(conn, params) do
    case Accounts.invite_user(params) do
      {:ok, org_invite} ->
        # TODO: we should probably create a token for this so you can't just send requests to accept invites
        org_invite = Accounts.get_org_invite!(org_invite.id)

        Accounts.deliver_invite(org_invite, Routes.org_invite_url(conn, :accept, org_invite.id))

        conn
        |> put_flash(
          :info,
          "An invite email has been sent."
        )
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", user_invite_changeset: changeset)
    end
  end

  def update(conn, %{"action" => "update_email"} = params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_update_email_instructions(
          applied_user,
          user.email,
          &Routes.user_settings_url(conn, :confirm_email, &1)
        )

        conn
        |> put_flash(
          :info,
          "A link to confirm your email change has been sent to the new address."
        )
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", email_changeset: changeset)
    end
  end

  def update(conn, %{"action" => "update_password"} = params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> put_session(:user_return_to, Routes.user_settings_path(conn, :edit))
        |> UserAuth.log_in_user(user)

      {:error, changeset} ->
        render(conn, "edit.html", password_changeset: changeset)
    end
  end

  def confirm_email(conn, %{"token" => token}) do
    case Accounts.update_user_email(conn.assigns.current_user, token) do
      :ok ->
        conn
        |> put_flash(:info, "Email changed successfully.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      :error ->
        conn
        |> put_flash(:error, "Email change link is invalid or it has expired.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))
    end
  end

  def select_org(conn, %{"org_id" => org_id}) do
    org = Accounts.get_org!(org_id)
    BudgetTrackingTool.Repo.put_org_id(org_id)

    conn
    |> put_session(:org_id, org_id)
    |> put_flash(:info, "Changed active org to #{org.name}")
    |> redirect(to: Routes.book_show_path(conn, :show))
  end

  defp assign_settings_changesets(conn, _opts) do
    user = conn.assigns.current_user

    conn
    |> assign(:email_changeset, Accounts.change_user_email(user))
    |> assign(:password_changeset, Accounts.change_user_password(user))
    |> assign(:user_invite_changeset, OrgInvite.changeset(%OrgInvite{}, %{user_id: user.id}))
  end
end
