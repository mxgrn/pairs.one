defmodule PairsOneWeb.Router do
  use PairsOneWeb.Web, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(PairsOneWeb.Plug.Locale, "en")
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", PairsOneWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
    resources("/games", GameController, only: [:new, :create, :show])
  end

  scope "/:locale", PairsOneWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
    post("/games/random", GameController, :random)
    resources("/games", GameController, only: [:new, :create, :show, :index])

    # Diagnostics
    get("/healthcheck", HealthcheckController, :index)
    get("/healthcheck/crash", HealthcheckController, :crash)
    get("/healthcheck/process_crash", HealthcheckController, :process_crash)
  end
end
