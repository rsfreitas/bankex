defmodule Bankex.BankTest do
  use Bankex.DataCase

  alias Bankex.Bank

  describe "checking_account" do
    alias Bankex.Bank.CheckingAccount

    @valid_attrs %{balance: 42}
    @update_attrs %{balance: 43}
    @invalid_attrs %{balance: nil}

    def checking_account_fixture(attrs \\ %{}) do
      {:ok, checking_account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Bank.create_checking_account()

      checking_account
    end

    test "list_checking_account/0 returns all checking_account" do
      checking_account = checking_account_fixture()
      assert Bank.list_checking_account() == [checking_account]
    end

    test "get_checking_account!/1 returns the checking_account with given id" do
      checking_account = checking_account_fixture()
      assert Bank.get_checking_account!(checking_account.id) == checking_account
    end

    test "create_checking_account/1 with valid data creates a checking_account" do
      assert {:ok, %CheckingAccount{} = checking_account} = Bank.create_checking_account(@valid_attrs)
      assert checking_account.balance == 42
    end

    test "create_checking_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bank.create_checking_account(@invalid_attrs)
    end

    test "update_checking_account/2 with valid data updates the checking_account" do
      checking_account = checking_account_fixture()
      assert {:ok, %CheckingAccount{} = checking_account} = Bank.update_checking_account(checking_account, @update_attrs)
      assert checking_account.balance == 43
    end

    test "update_checking_account/2 with invalid data returns error changeset" do
      checking_account = checking_account_fixture()
      assert {:error, %Ecto.Changeset{}} = Bank.update_checking_account(checking_account, @invalid_attrs)
      assert checking_account == Bank.get_checking_account!(checking_account.id)
    end

    test "delete_checking_account/1 deletes the checking_account" do
      checking_account = checking_account_fixture()
      assert {:ok, %CheckingAccount{}} = Bank.delete_checking_account(checking_account)
      assert_raise Ecto.NoResultsError, fn -> Bank.get_checking_account!(checking_account.id) end
    end

    test "change_checking_account/1 returns a checking_account changeset" do
      checking_account = checking_account_fixture()
      assert %Ecto.Changeset{} = Bank.change_checking_account(checking_account)
    end
  end
end
