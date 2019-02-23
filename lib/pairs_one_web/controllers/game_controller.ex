defmodule PairsOneWeb.GameController do
  use PairsOneWeb.Web, :controller

  alias PairsOne.Game
  alias PairsOne.Telegram

  def new(conn, _params) do
    themes = PairsOne.Theme.list() |> Poison.encode!()
    render(conn, "new.html", mini_header: true, themes: themes)
  end

  def create(conn, %{"game" => game}) do
    game =
      if game[:random] == nil do
        Map.merge(game, %{"random" => false})
      else
        game
      end

    game = Game.create(game)
    ga_params = if length(game.players) == 1, do: [mode: "solo"], else: []
    redirect(conn, to: "/#{locale()}" <> game_path(conn, :show, game.id, ga_params))
  end

  def show(conn, %{"id" => id}) do
    if Game.exists?(id) do
      {:ok, themes} = PairsOne.Theme.list() |> Poison.encode()
      render(conn, "show.html", id: id, mini_header: true, themes: themes, full_width: true)
    else
      conn
      |> put_flash(:info, "Game does not exist (any longer), create a new one")
      |> redirect(to: game_path(conn, :new))
    end
  end

  def index(conn, _params) do
    games = PairsOne.PendingGames.index()
    themes = PairsOne.Theme.list() |> Poison.encode!()

    render(
      conn,
      "index.html",
      mini_header: true,
      has_pending_games?: Enum.any?(games),
      themes: themes
    )
  end

  def random(conn, _params) do
    pending_games = PairsOne.PendingGames.data_list()
    game = pending_games |> Enum.sort_by(&missing_players_number/1) |> List.first()

    if game do
      redirect(conn, to: game_path(conn, :show, game.id))
    else
      game =
        %{
          "theme" => "eighties",
          "board_size" => "6",
          "players_number" => "2",
          "visibility" => "public",
          "random" => true
        }
        |> Game.create()

      new_game_path = "/#{locale()}" <> game_path(conn, :show, game.id)

      new_game_url = "https://#{conn.host}#{new_game_path}"

      # Notify Telegram chat about new random game
      Telegram.notify_on_new_game(game, new_game_url)

      redirect(conn, to: new_game_path)
    end
  end

  defp missing_players_number(%{players: players}) do
    Enum.count(players, fn p -> p.name == "" end)
  end
end
