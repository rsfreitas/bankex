defmodule BankexWeb.UserController do
    use BankexWeb, :controller
    require Logger

    alias Bankex.Accounts
    alias Bankex.Accounts.User
    alias BankexWeb.Auth.Guardian
    alias Bankex.Bank

    action_fallback BankexWeb.FallbackController

    # Starts a new user with 1000 inside his checking account.
    def create(conn, %{"user" => user_params}) do
        with {:ok, %User{} = user} <- Accounts.create_user(user_params),
          {:ok, _checking_account} <- Bank.create_checking_account(%{user_id: user.id, balance: 1000}),
          {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
              conn
              |> put_status(:created)
              |> render("user.json", %{user: user, token: token})
        end
    end

    def signin(conn, %{"email" => email, "password" => password}) do
        with {:ok, user, token} <- Guardian.authenticate(email, password) do
          conn
          |> put_status(:created)
          |> render("user.json", %{user: user, token: token})
        end
    end

    def signout(conn, params) do
        conn
        |> Guardian.Plug.sign_out()
        |> render("logout.json", params)
    end

    defp transfer_to(dest, amount) do
        with {:ok, user} <- Accounts.get_by_email(dest),
            {:ok, checking_account} <- Bank.get_by_user_id(user.id) do
            nb = checking_account.balance + amount
            Logger.debug "Increase current balance from #{checking_account.balance} to #{nb}"
            Bank.update_checking_account(checking_account, %{balance: nb})
        end
    end

    defp remove_from(whom, amount) do
        nb = whom.balance - amount
        Logger.debug "Letting our balance now with #{nb}"
        Bank.update_checking_account(whom, %{balance: nb})
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
                    remove_from(checking_account, amount)
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
                    remove_from(checking_account, amount)
                    notify(user.email)
            end
        end
    end

    def statement(conn, _params) do
        text conn, "Creating bank statement for user X"
    end

    def full_statement(conn, _params) do
        text conn, "Creating bank statement for everyone"
    end
end
