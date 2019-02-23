defmodule PairsOneWeb.PageController do
  use PairsOneWeb.Web, :controller

  def index(conn, _params) do
    themes = PairsOne.Theme.list() |> Poison.encode!()
    render(conn, "index.#{locale()}.html", themes: themes)
  end
end
