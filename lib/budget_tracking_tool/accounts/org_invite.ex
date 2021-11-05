defmodule BudgetTrackingTool.Accounts.OrgInvite do
  use Ecto.Schema
  import Ecto.Changeset

  @status_pending :pending
  @status_accepted :accepted
  @status_rejected :rejected

  schema "org_invites" do
    field :status, Ecto.Enum, values: [@status_pending, @status_accepted, @status_rejected]
    field :email, :string

    belongs_to :org, BudgetTrackingTool.Accounts.Org
    belongs_to :user, BudgetTrackingTool.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(org_invite, attrs) do
    org_invite
    |> cast(attrs, [:status, :email, :org_id, :user_id])
    |> validate_required([:status, :email, :org_id, :user_id])
  end

  def status_pending, do: @status_pending
  def status_accepted, do: @status_accepted
  def status_rejected, do: @status_rejected
end
