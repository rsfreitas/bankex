defmodule BankexWeb.UserController do
    use BankexWeb, :controller

    alias Bankex.Accounts
    alias Bankex.Accounts.User
    alias BankexWeb.Auth.Guardian

    action_fallback BankexWeb.FallbackController

    def create(conn, %{"user" => user_params}) do
        with {:ok, %User{} = user} <- Accounts.create_user(user_params),
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

    def transfer(conn, %{"dest" => dest, "amount" => amount}) do
        text conn, "Transfering from A to B..."
    end

    def withdraw(conn, %{"amount" => amount}) do
        text conn, "Withdrawing #{amount} from someones account"
    end

    def statement(conn, _params) do
        text conn, "Creating bank statement for user X"
    end

    def full_statement(conn, _params) do
        text conn, "Creating bank statement for everyone"
    end
end
