# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :kosynierzy,
  ecto_repos: [Kosynierzy.Repo]

# Configures the Repo
config :kosynierzy, Kosynierzy.Repo,
  migration_primary_key: [name: :id, type: :uuid],
  migration_timestamps: [type: :utc_datetime]

# Configures the endpoint
config :kosynierzy, KosynierzyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "KLO0PVXXY4WVHdCAOa4nVen1IV8BaGZcRwAuPiAHxQ/FeBtPerECSNyPec9xqXxf",
  render_errors: [view: KosynierzyWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Kosynierzy.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
