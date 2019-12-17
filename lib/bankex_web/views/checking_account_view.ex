defmodule BankexWeb.CheckingAccountView do
  use BankexWeb, :view
  alias BankexWeb.CheckingAccountView

  def render("index.json", %{checking_account: checking_account}) do
    %{data: render_many(checking_account, CheckingAccountView, "checking_account.json")}
  end

  def render("show.json", %{checking_account: checking_account}) do
    %{data: render_one(checking_account, CheckingAccountView, "checking_account.json")}
  end

  def render("checking_account.json", %{checking_account: checking_account}) do
    %{id: checking_account.id,
      balance: checking_account.balance}
  end
end
