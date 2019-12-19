defmodule BankexWeb.Router do
  use BankexWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug BankexWeb.Auth.Pipeline
  end

  scope "/api", BankexWeb do
    pipe_through :api
    post "/signup", UserController, :create
    post "/signin", UserController, :signin
  end

  scope "/api", BankexWeb do
    pipe_through [:api, :auth]
    post "/signout", UserController, :signout
    post "/transfer", TransactionsController, :transfer
    post "/withdraw", TransactionsController, :withdraw
    get "/statement", TransactionsController, :statement
    get "/full-statement", TransactionsController, :full_statement
  end
end
