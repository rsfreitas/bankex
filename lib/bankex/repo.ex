defmodule Bankex.Repo do
  use Ecto.Repo,
    otp_app: :bankex,
    adapter: Ecto.Adapters.Postgres
end
