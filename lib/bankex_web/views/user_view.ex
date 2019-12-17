defmodule BankexWeb.UserView do
  use BankexWeb, :view

  def render("user.json", %{user: user, token: token}) do
    %{
      email: user.email,
      token: token
    }
  end

  def render("logout.json", _) do
    %{
      message: "logged out"
    }
  end
end
