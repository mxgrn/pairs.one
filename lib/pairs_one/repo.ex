defmodule PairsOne.Repo do
  use Ecto.Repo,
    otp_app: :pairs_one,
    adapter: Ecto.Adapters.Postgres
end
