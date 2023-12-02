defmodule PairsOneWeb.Router do
  use PairsOneWeb.Web, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :enforce_locale do
    plug(PairsOneWeb.Plug.Locale, "en")
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", PairsOneWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
    resources("/games", GameController, only: [:new, :create, :show])

    # Diagnostics
    get("/health", HealthcheckController, :index)
    get("/health/crash", HealthcheckController, :crash)
    get("/health/process_crash", HealthcheckController, :process_crash)
  end

  scope "/:locale", PairsOneWeb do
    pipe_through([:browser, :enforce_locale])

    get("/", PageController, :index)
    post("/games/random", GameController, :random)
    resources("/games", GameController, only: [:new, :create, :show, :index])
  end
end
