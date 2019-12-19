defmodule BankexWeb.UserController do
    use BankexWeb, :controller

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
end
