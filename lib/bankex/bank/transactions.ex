defmodule Bankex.Bank.Transactions do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :amount, :integer
    field :current_balance, :integer
    field :type, :integer
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(transactions, attrs) do
    transactions
    |> cast(attrs, [:amount, :type, :current_balance, :user_id])
    |> validate_required([:amount, :type, :current_balance, :user_id])
  end

  @transfer_received 1
  def transfer_received, do: @transfer_received

  @transfer_sent 2
  def transfer_sent, do: @transfer_sent

  @withdraw 3
  def withdraw, do: @withdraw

  def type_to_str(type) do
    case type do
        @transfer_received -> "received"
        @transfer_sent -> "sent"
        @withdraw -> "withdraw"
        _ -> "unknown"
    end
  end
end
