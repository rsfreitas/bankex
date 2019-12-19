defmodule BankexWeb.TransactionsView do
  use BankexWeb, :view

  alias BankexWeb.TransactionsView
  alias Bankex.Bank.Transactions

  def render("index.json", %{transactions: transactions}) do
    %{data: render_many(transactions, TransactionsView, "transactions.json")}
  end

  def render("show.json", %{transactions: transactions}) do
    %{data: render_one(transactions, TransactionsView, "transactions.json")}
  end

  defp get_details([head | transactions], details) do
    get_details(transactions, details ++ [%{time: head.inserted_at,
                                            amount: head.amount,
                                            operation: Transactions.type_to_str(head.type)}])
  end

  defp get_details([], details) do
    details
  end

  defp get_transactions(transactions) do
    case transactions do
        [] -> nil
        _ ->
            added = Enum.reduce(transactions, 0, fn transaction, acc ->
                if transaction.type == Transactions.transfer_received, do: acc + transaction.amount, else: acc
            end)
            removed = Enum.reduce(transactions, 0, fn transaction, acc ->
                if transaction.type == Transactions.transfer_sent or transaction.type == Transactions.withdraw do
                    acc + transaction.amount
                else
                    acc
                end
            end)
            total = added - removed
            details = get_details(transactions, [])
            %{total: total, details: details}
    end
  end

  # TODO: handle nil case
  def render("transactions.json", %{transactions: transactions}) do
    get_transactions(transactions)
  end

  defp get_users([head | tail], users) do
    {:user, username, :transactions, transactions} = head
    get_users(tail, users ++ [%{username: username,
                                transactions: get_transactions(transactions)}])
  end

  defp get_users([], users) do
    users
  end

  def render("full_transactions.json", %{full_transactions: transactions}) do
    %{users: get_users(transactions, [])}
  end
end
