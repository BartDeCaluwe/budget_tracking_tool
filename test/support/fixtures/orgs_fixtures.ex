defmodule BudgetTrackingTool.OrgsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  organizations via the `BudgetTrackingTool.Accounts` context.
  """

  @doc """
  Generate an org.
  """
  def org_fixture(attrs \\ %{}) do
    {:ok, org} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> BudgetTrackingTool.Accounts.create_org()

    org
  end
end
