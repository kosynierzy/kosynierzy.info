defmodule Kosynierzy.Repo do
  use Ecto.Repo,
    otp_app: :kosynierzy,
    adapter: Ecto.Adapters.Postgres
end
