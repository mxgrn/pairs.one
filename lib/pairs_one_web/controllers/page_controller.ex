defmodule PairsOneWeb.PageController do
  use PairsOneWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", themes: PairsOne.Theme.list() |> Poison.encode!())
  end
end
