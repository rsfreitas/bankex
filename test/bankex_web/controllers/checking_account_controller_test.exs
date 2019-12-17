defmodule BankexWeb.CheckingAccountControllerTest do
  use BankexWeb.ConnCase

  alias Bankex.Bank
  alias Bankex.Bank.CheckingAccount

  @create_attrs %{
    balance: 42
  }
  @update_attrs %{
    balance: 43
  }
  @invalid_attrs %{balance: nil}

  def fixture(:checking_account) do
    {:ok, checking_account} = Bank.create_checking_account(@create_attrs)
    checking_account
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all checking_account", %{conn: conn} do
      conn = get(conn, Routes.checking_account_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create checking_account" do
    test "renders checking_account when data is valid", %{conn: conn} do
      conn = post(conn, Routes.checking_account_path(conn, :create), checking_account: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.checking_account_path(conn, :show, id))

      assert %{
               "id" => id,
               "balance" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.checking_account_path(conn, :create), checking_account: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update checking_account" do
    setup [:create_checking_account]

    test "renders checking_account when data is valid", %{conn: conn, checking_account: %CheckingAccount{id: id} = checking_account} do
      conn = put(conn, Routes.checking_account_path(conn, :update, checking_account), checking_account: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.checking_account_path(conn, :show, id))

      assert %{
               "id" => id,
               "balance" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, checking_account: checking_account} do
      conn = put(conn, Routes.checking_account_path(conn, :update, checking_account), checking_account: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete checking_account" do
    setup [:create_checking_account]

    test "deletes chosen checking_account", %{conn: conn, checking_account: checking_account} do
      conn = delete(conn, Routes.checking_account_path(conn, :delete, checking_account))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.checking_account_path(conn, :show, checking_account))
      end
    end
  end

  defp create_checking_account(_) do
    checking_account = fixture(:checking_account)
    {:ok, checking_account: checking_account}
  end
end
