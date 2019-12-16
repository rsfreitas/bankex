# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bankex,
  ecto_repos: [Bankex.Repo]

# Configures the endpoint
config :bankex, BankexWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1Chk+0Ih/7d4jao9/xo1A+fTOJXMjoW0K+NAthnLMSmXB1VV1EjXYVu9lj07US/h",
  render_errors: [view: BankexWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Bankex.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :bankex, BankexWeb.Auth.Guardian,
    issuer: "bankex",
    secret_key: "ooQd5xAXw+cg3Z9FTQ1tENOqKIeR4ZDUmpR/U4AjA9kU1k0NmoBs2uqGMnbp4j81"

