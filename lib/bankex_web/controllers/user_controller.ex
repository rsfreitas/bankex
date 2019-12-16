defmodule BankexWeb.UserController do
    use BankexWeb, :controller

    alias BankexWeb.Auth.Guardian

    def create(conn, %{"username" => username}) do
        text conn, "Signup user #{username}"
    end

    def signin(conn, %{"username" => username, "password" => password}) do
        text conn, "User signing in..."
    end

    def transfer(conn, %{"token" => token, "dest" => dest, "amount" => amount}) do
        text conn, "Transfering from A to B..."
    end

    def withdraw(conn, %{"token" => token, "amount" => amount}) do
        text conn, "Withdrawing #{amount} from someones account"
    end

    def statement(conn, _params) do
        text conn, "Creating bank statement for user X"
    end

    def full_statement(conn, _params) do
        text conn, "Creating bank statement for everyone"
    end
end

