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
    post "/transfer", UserController, :transfer
    post "/withdraw", UserController, :withdraw
    post "/statement", UserController, :statement
    post "/full-statement", UserController, :full_statement
  end

  pipeline :browser do
    plug(:accepts, ["html"])
  end

  scope "/", BankexWeb do
    pipe_through :browser
    get "/", DefaultController, :index
  end
end
