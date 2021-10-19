defmodule BudgetTrackingTool.Dates do
  @moduledoc """
  The Dates context.
  """

  use Timex

  def beginning_of_month(month, year) do
    Timex.to_date({year, month, 1})
    |> Timex.beginning_of_month()
  end

  def naive_beginning_of_month(month, year) do
    Timex.to_naive_datetime({year, month, 1})
    |> Timex.beginning_of_month()
  end

  def end_of_month(month, year) do
    Timex.to_date({year, month, 1})
    |> Timex.end_of_month()
  end

  def naive_end_of_month(month, year) do
    Timex.to_naive_datetime({year, month, 1})
    |> Timex.end_of_month()
  end
end
