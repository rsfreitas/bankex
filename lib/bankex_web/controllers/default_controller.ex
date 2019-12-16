defmodule BankexWeb.DefaultController do
    use BankexWeb, :controller

    def index(conn, _params) do
        text conn, "Bankex running..."
    end
end

