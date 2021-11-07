defmodule BudgetTrackingTool.PayeesFixtures do
  alias BudgetTrackingTool.Accounts.Org

  @moduledoc """
  This module defines test helpers for creating
  entities via the `BudgetTrackingTool.Payees` context.
  """

  @doc """
  Generate a payee.
  """
  def payee_fixture(attrs \\ %{}) do
    %Org{id: org_id} = BudgetTrackingTool.OrgsFixtures.org_fixture()

    {:ok, payee} =
      attrs
      |> Enum.into(%{
        name: "some name",
        org_id: org_id
      })
      |> BudgetTrackingTool.Payees.create_payee()

    payee
  end
end
