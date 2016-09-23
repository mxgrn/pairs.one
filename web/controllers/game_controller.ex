defmodule PairsOne.GameController do
  use PairsOne.Web, :controller

  alias PairsOne.Game

  def new(conn, _params) do
    themes = PairsOne.Theme.list
    render conn, "new.html", mini_header: true, themes: themes
  end

  def create(conn, %{"game" => game}) do
    game = PairsOne.Game.create(game)
    redirect(conn, to: "/#{locale}" <> game_path(conn, :show, game.id))
  end

  def show(conn, %{"id" => id}) do
    if Game.exists?(id) do
      {:ok, themes} = PairsOne.Theme.list |> Poison.encode
      render conn, "show.html", id: id, mini_header: true, themes: themes, show_new_link: true
    else
      conn
      |> put_flash(:info, "Game does not exist (any longer), create a new one")
      |> redirect(to: game_path(conn, :new))
    end
  end
end
