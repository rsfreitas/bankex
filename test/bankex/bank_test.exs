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

  describe "transactions" do
    alias Bankex.Bank.Transactions

    @valid_attrs %{amount: 42, type: 42}
    @update_attrs %{amount: 43, type: 43}
    @invalid_attrs %{amount: nil, type: nil}

    def transactions_fixture(attrs \\ %{}) do
      {:ok, transactions} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Bank.create_transactions()

      transactions
    end

    test "list_transactions/0 returns all transactions" do
      transactions = transactions_fixture()
      assert Bank.list_transactions() == [transactions]
    end

    test "get_transactions!/1 returns the transactions with given id" do
      transactions = transactions_fixture()
      assert Bank.get_transactions!(transactions.id) == transactions
    end

    test "create_transactions/1 with valid data creates a transactions" do
      assert {:ok, %Transactions{} = transactions} = Bank.create_transactions(@valid_attrs)
      assert transactions.amount == 42
      assert transactions.type == 42
    end

    test "create_transactions/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bank.create_transactions(@invalid_attrs)
    end

    test "update_transactions/2 with valid data updates the transactions" do
      transactions = transactions_fixture()
      assert {:ok, %Transactions{} = transactions} = Bank.update_transactions(transactions, @update_attrs)
      assert transactions.amount == 43
      assert transactions.type == 43
    end

    test "update_transactions/2 with invalid data returns error changeset" do
      transactions = transactions_fixture()
      assert {:error, %Ecto.Changeset{}} = Bank.update_transactions(transactions, @invalid_attrs)
      assert transactions == Bank.get_transactions!(transactions.id)
    end

    test "delete_transactions/1 deletes the transactions" do
      transactions = transactions_fixture()
      assert {:ok, %Transactions{}} = Bank.delete_transactions(transactions)
      assert_raise Ecto.NoResultsError, fn -> Bank.get_transactions!(transactions.id) end
    end

    test "change_transactions/1 returns a transactions changeset" do
      transactions = transactions_fixture()
      assert %Ecto.Changeset{} = Bank.change_transactions(transactions)
    end
  end

  describe "transactions" do
    alias Bankex.Bank.Transactions

    @valid_attrs %{amount: 42, current_balance: 42, type: 42}
    @update_attrs %{amount: 43, current_balance: 43, type: 43}
    @invalid_attrs %{amount: nil, current_balance: nil, type: nil}

    def transactions_fixture(attrs \\ %{}) do
      {:ok, transactions} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Bank.create_transactions()

      transactions
    end

    test "list_transactions/0 returns all transactions" do
      transactions = transactions_fixture()
      assert Bank.list_transactions() == [transactions]
    end

    test "get_transactions!/1 returns the transactions with given id" do
      transactions = transactions_fixture()
      assert Bank.get_transactions!(transactions.id) == transactions
    end

    test "create_transactions/1 with valid data creates a transactions" do
      assert {:ok, %Transactions{} = transactions} = Bank.create_transactions(@valid_attrs)
      assert transactions.amount == 42
      assert transactions.current_balance == 42
      assert transactions.type == 42
    end

    test "create_transactions/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bank.create_transactions(@invalid_attrs)
    end

    test "update_transactions/2 with valid data updates the transactions" do
      transactions = transactions_fixture()
      assert {:ok, %Transactions{} = transactions} = Bank.update_transactions(transactions, @update_attrs)
      assert transactions.amount == 43
      assert transactions.current_balance == 43
      assert transactions.type == 43
    end

    test "update_transactions/2 with invalid data returns error changeset" do
      transactions = transactions_fixture()
      assert {:error, %Ecto.Changeset{}} = Bank.update_transactions(transactions, @invalid_attrs)
      assert transactions == Bank.get_transactions!(transactions.id)
    end

    test "delete_transactions/1 deletes the transactions" do
      transactions = transactions_fixture()
      assert {:ok, %Transactions{}} = Bank.delete_transactions(transactions)
      assert_raise Ecto.NoResultsError, fn -> Bank.get_transactions!(transactions.id) end
    end

    test "change_transactions/1 returns a transactions changeset" do
      transactions = transactions_fixture()
      assert %Ecto.Changeset{} = Bank.change_transactions(transactions)
    end
  end
end
