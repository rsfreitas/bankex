defmodule BankexWeb.TransactionsController do
    use BankexWeb, :controller
    require Logger

    alias Bankex.Accounts
    alias BankexWeb.Auth.Guardian
    alias Bankex.Bank
    alias Bankex.Bank.Transactions

    action_fallback BankexWeb.FallbackController

    defp transfer_to(dest, amount) do
        with {:ok, user} <- Accounts.get_by_email(dest),
            {:ok, checking_account} <- Bank.get_by_user_id(user.id) do
            nb = checking_account.balance + amount
            Logger.debug "Increase current balance from #{checking_account.balance} to #{nb}"
            Bank.update_checking_account(checking_account, %{balance: nb})
            Bank.create_transactions(%{user_id: user.id, amount: amount,
                                       current_balance: checking_account.balance,
                                       type: Transactions.transfer_received})
        end
    end

    defp remove_from(whom, amount, action_type) do
        nb = whom.balance - amount
        Logger.debug "Letting our balance now with #{nb}"
        Bank.update_checking_account(whom, %{balance: nb})
        Bank.create_transactions(%{user_id: whom.user_id, amount: amount,
                                   current_balance: whom.balance,
                                   type: action_type})
    end

    def transfer(conn, %{"dest" => dest, "amount" => amount}) do
        token = Guardian.Plug.current_token(conn)
        with {:ok, user, _claims} <- Guardian.resource_from_token(token),
            {:ok, checking_account} <- Bank.get_by_user_id(user.id) do
            Logger.debug "user: #{user.email}, #{user.id}"
            Logger.debug "checking account: #{checking_account.balance}"
            cond do
                checking_account.balance - amount < 0 ->
                    Logger.debug "Cannot transfer because we will be negative"
                    {:error, :insufficient_balance}
                true ->
                    Logger.debug "Transfer to B"
                    transfer_to(dest, amount)
                    remove_from(checking_account, amount, Transactions.transfer_sent)
                    text conn, "Transfering from A to B: #{token}..."
            end
        end
    end

    defp notify(email) do
        Logger.info "Sending email to #{email}"
    end

    def withdraw(conn, %{"amount" => amount}) do
        token = Guardian.Plug.current_token(conn)
        with {:ok, user, _claims} <- Guardian.resource_from_token(token),
            {:ok, checking_account} <- Bank.get_by_user_id(user.id) do
            Logger.debug "user: #{user.email}, #{user.id}"
            Logger.debug "checking account: #{checking_account.balance}"
            cond do
                checking_account.balance - amount < 0 ->
                    Logger.debug "Cannot transfer because we will be negative"
                    {:error, :insufficient_balance}
                true ->
                    Logger.debug "Transfer to B"
                    remove_from(checking_account, amount, Transactions.withdraw)
                    notify(user.email)
                    {:ok, []}
            end
        end
    end

    defp get_transactions(params, user) do
        case params do
            # /statement?day=X&month=Y&year=Z
            %{"day" => day, "month" => month, "year" => year} ->
                Bank.get_transactions_from_user(:day, user.id, day, month, year)
            # /statement?day_range=X-Y&month=Z&year=A
            %{"day_range" => range, "month" => month, "year" => year} ->
                Bank.get_transactions_from_user(:day_range, user.id, range, month, year)
            # /statement?month=X&year=Y
            %{"month" => month, "year" => year} ->
                Bank.get_transactions_from_user(:month, user.id, month, year)
            # /statement?month_range=X-Y&year=Z
            %{"month_range" => range, "year" => year} ->
                Bank.get_transactions_from_user(:month_range, user.id, range, year)
            # /statement
            %{} ->
                Bank.get_transactions_from_user(:full, user.id)
        end
    end

    def statement(conn, params) do
        token = Guardian.Plug.current_token(conn)
        with {:ok, user, _claims} <- Guardian.resource_from_token(token) do
            with {:ok, transactions} <- get_transactions(params, user) do
                conn
                |> put_status(:ok)
                |> render("transactions.json", %{transactions: transactions})
            end
        end
    end

    defp get_users_transactions([head | tail], user_transactions) do
        case get_transactions(%{}, head) do
            {:ok, transactions} ->
                get_users_transactions(tail, user_transactions ++ [{:user, head.email,
                                                                    :transactions, transactions}])
            _ ->
                get_users_transactions(tail, user_transactions ++ [{:user, head.email,
                                                                    :transactions, {}}])
        end
    end

    defp get_users_transactions([], user_transactions) do
        user_transactions
    end

    def full_statement(conn, _params) do
        full_transactions = get_users_transactions(Accounts.list_users(), [])
        conn
        |> put_status(:ok)
        |> render("full_transactions.json", %{full_transactions: full_transactions})
    end
end
