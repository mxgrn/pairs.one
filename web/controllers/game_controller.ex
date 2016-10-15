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

  def index(conn, _params) do
    games = PairsOne.PendingGames.index
    themes = PairsOne.Theme.list |> Poison.encode!
    render conn, "index.html", mini_header: true, has_pending_games?: Enum.any?(games), themes: themes
  end

  def random(conn, _params) do
    pending_games = PairsOne.PendingGames.data_list
    game = pending_games |> Enum.sort_by(&missing_players_number/1) |> List.first
    if game do
      redirect(conn, to: game_path(conn, :show, game.id))
    else
      conn
      |> put_flash(:warning, "There are no pending games at this moment - start one now!")
      |>
      redirect(to: "/#{locale}" )
    end
  end

  defp last_missing_player?(%{players: players}) do
    Enum.count(players, fn(p) -> p.name == "" end) == 1
  end

  defp missing_players_number(%{players: players}) do
    Enum.count(players, fn(p) -> p.name == "" end)
  end
end
