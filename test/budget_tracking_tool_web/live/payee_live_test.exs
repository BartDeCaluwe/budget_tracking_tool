defmodule BudgetTrackingToolWeb.PayeeLiveTest do
  use BudgetTrackingToolWeb.ConnCase

  import Phoenix.LiveViewTest
  import BudgetTrackingTool.PayeesFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_payee(_) do
    payee = payee_fixture()
    %{payee: payee}
  end

  describe "Index" do
    setup [:create_payee]

    test "lists all payees", %{conn: conn, payee: payee} do
      {:ok, _index_live, html} = live(conn, Routes.payee_index_path(conn, :index))

      assert html =~ "Listing Payees"
      assert html =~ payee.name
    end

    test "saves new payee", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.payee_index_path(conn, :index))

      assert index_live |> element("a", "New Payee") |> render_click() =~
               "New Payee"

      assert_patch(index_live, Routes.payee_index_path(conn, :new))

      assert index_live
             |> form("#payee-form", payee: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#payee-form", payee: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.payee_index_path(conn, :index))

      assert html =~ "Payee created successfully"
      assert html =~ "some name"
    end

    test "updates payee in listing", %{conn: conn, payee: payee} do
      {:ok, index_live, _html} = live(conn, Routes.payee_index_path(conn, :index))

      assert index_live |> element("#payee-#{payee.id} a", "Edit") |> render_click() =~
               "Edit Payee"

      assert_patch(index_live, Routes.payee_index_path(conn, :edit, payee))

      assert index_live
             |> form("#payee-form", payee: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#payee-form", payee: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.payee_index_path(conn, :index))

      assert html =~ "Payee updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes payee in listing", %{conn: conn, payee: payee} do
      {:ok, index_live, _html} = live(conn, Routes.payee_index_path(conn, :index))

      assert index_live |> element("#payee-#{payee.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#payee-#{payee.id}")
    end
  end

  describe "Show" do
    setup [:create_payee]

    test "displays payee", %{conn: conn, payee: payee} do
      {:ok, _show_live, html} = live(conn, Routes.payee_show_path(conn, :show, payee))

      assert html =~ "Show Payee"
      assert html =~ payee.name
    end

    test "updates payee within modal", %{conn: conn, payee: payee} do
      {:ok, show_live, _html} = live(conn, Routes.payee_show_path(conn, :show, payee))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Payee"

      assert_patch(show_live, Routes.payee_show_path(conn, :edit, payee))

      assert show_live
             |> form("#payee-form", payee: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#payee-form", payee: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.payee_show_path(conn, :show, payee))

      assert html =~ "Payee updated successfully"
      assert html =~ "some updated name"
    end
  end
end
