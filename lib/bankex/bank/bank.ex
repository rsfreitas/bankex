defmodule Bankex.Bank do
  @moduledoc """
  The Bank context.
  """

  import Ecto.Query, warn: false
  alias Bankex.Repo

  alias Bankex.Bank.CheckingAccount

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
end
