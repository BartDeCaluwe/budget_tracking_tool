defmodule BudgetTrackingTool.PayeesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BudgetTrackingTool.Payees` context.
  """

  @doc """
  Generate a payee.
  """
  def payee_fixture(attrs \\ %{}) do
    {:ok, payee} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> BudgetTrackingTool.Payees.create_payee()

    payee
  end
end
