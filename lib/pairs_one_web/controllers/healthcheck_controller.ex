defmodule PairsOneWeb.HealthcheckController do
  use PairsOneWeb.Web, :controller

  def index(conn, _params) do
    :ok = Exredis.Api.set(:redis, "foo", "bar")

    json(conn, %{
      name: "pairs_one",
      env: Application.get_env(:pairs_one, :env),
      port: System.get_env("PORT"),
      release_sha: Application.get_env(:pairs_one, :release_sha)
    })
  end

  def crash(_conn, _params) do
    raise "Intentional crash"
  end

  def process_crash(conn, _params) do
    Task.start(fn ->
      raise "Intentional process crash"
    end)

    json(conn, %{result: "Logged an error"})
  end
end
