defmodule Adam.Repo do
  use Ecto.Repo,
    otp_app: :adam,
    adapter: Ecto.Adapters.Postgres
end
