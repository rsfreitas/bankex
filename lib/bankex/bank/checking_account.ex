defmodule Bankex.Bank.CheckingAccount do
  use Ecto.Schema
  import Ecto.Changeset

  schema "checking_account" do
    field :balance, :integer
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(checking_account, attrs) do
    checking_account
    |> cast(attrs, [:balance, :user_id])
    |> validate_required([:balance])
    |> validate_required([:user_id])
  end
end
