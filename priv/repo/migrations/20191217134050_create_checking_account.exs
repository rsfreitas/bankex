defmodule Bankex.Repo.Migrations.CreateCheckingAccount do
  use Ecto.Migration

  def change do
    create table(:checking_account) do
      add :balance, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:checking_account, [:user_id])
  end
end
