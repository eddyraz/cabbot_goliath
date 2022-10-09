defmodule Cabbot.Repo do
  use Ecto.Repo,
    otp_app: :cabbot,
    adapter: Ecto.Adapters.Postgres
end
