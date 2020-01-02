defmodule BankexWeb.TransactionsControllerTest do
  use BankexWeb.ConnCase

  alias Bankex.Bank
  alias Bankex.Bank.Transactions

  @create_attrs %{
    amount: 42,
    current_balance: 42,
    type: 42
  }
  @update_attrs %{
    amount: 43,
    current_balance: 43,
    type: 43
  }
  @invalid_attrs %{amount: nil, current_balance: nil, type: nil}

  def fixture(:transactions) do
    {:ok, transactions} = Bank.create_transactions(@create_attrs)
    transactions
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all transactions", %{conn: conn} do
      conn = get(conn, Routes.transactions_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create transactions" do
    test "renders transactions when data is valid", %{conn: conn} do
      conn = post(conn, Routes.transactions_path(conn, :create), transactions: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.transactions_path(conn, :show, id))

      assert %{
               "id" => id,
               "amount" => 42,
               "current_balance" => 42,
               "type" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.transactions_path(conn, :create), transactions: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update transactions" do
    setup [:create_transactions]

    test "renders transactions when data is valid", %{conn: conn, transactions: %Transactions{id: id} = transactions} do
      conn = put(conn, Routes.transactions_path(conn, :update, transactions), transactions: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.transactions_path(conn, :show, id))

      assert %{
               "id" => id,
               "amount" => 43,
               "current_balance" => 43,
               "type" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, transactions: transactions} do
      conn = put(conn, Routes.transactions_path(conn, :update, transactions), transactions: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete transactions" do
    setup [:create_transactions]

    test "deletes chosen transactions", %{conn: conn, transactions: transactions} do
      conn = delete(conn, Routes.transactions_path(conn, :delete, transactions))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.transactions_path(conn, :show, transactions))
      end
    end
  end

  defp create_transactions(_) do
    transactions = fixture(:transactions)
    {:ok, transactions: transactions}
  end
end
