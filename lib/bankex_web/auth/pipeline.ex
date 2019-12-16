defmodule BankexWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :busi_api,
    module: BankexWeb.Auth.Guardian,
    error_handler: BankexWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end

