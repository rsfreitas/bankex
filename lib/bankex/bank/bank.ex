defmodule Bankex.Bank do
  @moduledoc """
  The Bank context.
  """

  import Ecto.Query, warn: false
  alias Bankex.Repo

  alias Bankex.Bank.CheckingAccount
  alias Bankex.Bank.Transactions

  @doc """
  Returns the list of checking_account.

  ## Examples

      iex> list_checking_account()
      [%CheckingAccount{}, ...]

  """
  def list_checking_account do
    Repo.all(CheckingAccount)
  end

  @doc """
  Gets a single checking_account.

  Raises `Ecto.NoResultsError` if the Checking account does not exist.

  ## Examples

      iex> get_checking_account!(123)
      %CheckingAccount{}

      iex> get_checking_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_checking_account!(id), do: Repo.get!(CheckingAccount, id)

  @doc """
  Creates a checking_account.

  ## Examples

      iex> create_checking_account(%{field: value})
      {:ok, %CheckingAccount{}}

      iex> create_checking_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_checking_account(attrs \\ %{}) do
    %CheckingAccount{}
    |> CheckingAccount.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a checking_account.

  ## Examples

      iex> update_checking_account(checking_account, %{field: new_value})
      {:ok, %CheckingAccount{}}

      iex> update_checking_account(checking_account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_checking_account(%CheckingAccount{} = checking_account, attrs) do
    checking_account
    |> CheckingAccount.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a CheckingAccount.

  ## Examples

      iex> delete_checking_account(checking_account)
      {:ok, %CheckingAccount{}}

      iex> delete_checking_account(checking_account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_checking_account(%CheckingAccount{} = checking_account) do
    Repo.delete(checking_account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking checking_account changes.

  ## Examples

      iex> change_checking_account(checking_account)
      %Ecto.Changeset{source: %CheckingAccount{}}

  """
  def change_checking_account(%CheckingAccount{} = checking_account) do
    CheckingAccount.changeset(checking_account, %{})
  end

  def get_by_user_id(user_id) do
    case Repo.get_by(CheckingAccount, user_id: user_id) do
        nil ->
            {:error, :not_found}
        checking_account ->
            {:ok, checking_account}
    end
  end

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transactions{}, ...]

  """
  def list_transactions do
    Repo.all(Transactions)
  end

  @doc """
  Gets a single transactions.

  Raises `Ecto.NoResultsError` if the Transactions does not exist.

  ## Examples

      iex> get_transactions!(123)
      %Transactions{}

      iex> get_transactions!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transactions!(id), do: Repo.get!(Transactions, id)

  @doc """
  Creates a transactions.

  ## Examples

      iex> create_transactions(%{field: value})
      {:ok, %Transactions{}}

      iex> create_transactions(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transactions(attrs \\ %{}) do
    %Transactions{}
    |> Transactions.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transactions.

  ## Examples

      iex> update_transactions(transactions, %{field: new_value})
      {:ok, %Transactions{}}

      iex> update_transactions(transactions, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transactions(%Transactions{} = transactions, attrs) do
    transactions
    |> Transactions.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Transactions.

  ## Examples

      iex> delete_transactions(transactions)
      {:ok, %Transactions{}}

      iex> delete_transactions(transactions)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transactions(%Transactions{} = transactions) do
    Repo.delete(transactions)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transactions changes.

  ## Examples

      iex> change_transactions(transactions)
      %Ecto.Changeset{source: %Transactions{}}

  """
  def change_transactions(%Transactions{} = transactions) do
    Transactions.changeset(transactions, %{})
  end

  def get_transactions_from_user(:full, id) do
    query = from t in Transactions, where: t.user_id == ^id
    case Repo.all(query) do
        nil ->
            {:error, :not_found}
        transactions ->
            {:ok, transactions}
    end
  end

  defp get_by_date_range(id, {begin_year, begin_month, begin_day}, {end_year, end_month, end_day}) do
    {:ok, begin} = NaiveDateTime.from_erl({{begin_year, begin_month, begin_day}, {0, 0, 0}})
    {:ok, end_date} = NaiveDateTime.from_erl({{end_year, end_month, end_day}, {23, 59, 59}})
    query = from t in Transactions,
        where: t.user_id == ^id and t.inserted_at >= ^begin and t.inserted_at <= ^end_date
    case Repo.all(query) do
        nil ->
            {:error, :not_found}
        transactions ->
            {:ok, transactions}
    end
  end

  def get_transactions_from_user(:month_range, id, range, year) do
    [min, max] = String.split(range, "-", trim: true) |> Enum.map(&String.to_integer/1)
    get_by_date_range(id, {String.to_integer(year), String.to_integer(min), 1},
                      {String.to_integer(year), String.to_integer(max), 31})
  end

  def get_transactions_from_user(:month, id, month, year) do
    get_by_date_range(id, {String.to_integer(year), String.to_integer(month), 1},
                      {String.to_integer(year), String.to_integer(month), 31})
  end

  def get_transactions_from_user(:day_range, id, range, month, year) do
    [min, max] = String.split(range, "-", trim: true) |> Enum.map(&String.to_integer/1)
    get_by_date_range(id, {String.to_integer(year), String.to_integer(month), String.to_integer(min)},
                      {String.to_integer(year), String.to_integer(month), String.to_integer(max)})
  end

  def get_transactions_from_user(:day, id, day, month, year) do
    get_by_date_range(id, {String.to_integer(year), String.to_integer(month), String.to_integer(day)},
                      {String.to_integer(year), String.to_integer(month), String.to_integer(day)})
  end
end
