defmodule PairsOne.Router do
  use PairsOne.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PairsOne.Plug.Locale, "en"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PairsOne do
    pipe_through :browser

    get "/", PageController, :index
    resources "/games", GameController, only: [:new, :create, :show]
  end

  scope "/:locale", PairsOne do
    pipe_through :browser

    get "/", PageController, :index
    resources "/games", GameController, only: [:new, :create, :show, :index]
  end
end
