use Mix.Config

# Configure your database
config :kosynierzy, Kosynierzy.Repo,
  username: "postgres",
  password: "postgres",
  database: "kosynierzy_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  port: System.get_env("DATABASE_PORT") || 5432

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :kosynierzy, KosynierzyWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
