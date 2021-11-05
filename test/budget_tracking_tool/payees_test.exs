defmodule BudgetTrackingTool.PayeesTest do
  use BudgetTrackingTool.DataCase

  alias BudgetTrackingTool.Payees

  describe "payees" do
    alias BudgetTrackingTool.Payees.Payee

    import BudgetTrackingTool.PayeesFixtures

    @invalid_attrs %{name: nil}

    test "list_payees/0 returns all payees" do
      payee = payee_fixture()
      assert Payees.list_payees() == [payee]
    end

    test "get_payee!/1 returns the payee with given id" do
      payee = payee_fixture()
      assert Payees.get_payee!(payee.id) == payee
    end

    test "create_payee/1 with valid data creates a payee" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Payee{} = payee} = Payees.create_payee(valid_attrs)
      assert payee.name == "some name"
    end

    test "create_payee/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payees.create_payee(@invalid_attrs)
    end

    test "update_payee/2 with valid data updates the payee" do
      payee = payee_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Payee{} = payee} = Payees.update_payee(payee, update_attrs)
      assert payee.name == "some updated name"
    end

    test "update_payee/2 with invalid data returns error changeset" do
      payee = payee_fixture()
      assert {:error, %Ecto.Changeset{}} = Payees.update_payee(payee, @invalid_attrs)
      assert payee == Payees.get_payee!(payee.id)
    end

    test "delete_payee/1 deletes the payee" do
      payee = payee_fixture()
      assert {:ok, %Payee{}} = Payees.delete_payee(payee)
      assert_raise Ecto.NoResultsError, fn -> Payees.get_payee!(payee.id) end
    end

    test "change_payee/1 returns a payee changeset" do
      payee = payee_fixture()
      assert %Ecto.Changeset{} = Payees.change_payee(payee)
    end
  end
end
