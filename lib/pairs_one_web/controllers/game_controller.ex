defmodule PairsOneWeb.GameController do
  use PairsOneWeb.Web, :controller

  alias PairsOne.Game

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
    redirect(conn, to: "/#{locale}" <> game_path(conn, :show, game.id, ga_params))
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

      new_game_path = "/#{locale}" <> game_path(conn, :show, game.id)
      new_game_uri = "https://#{conn.host}#{new_game_path}"

      # Notify @pairsone about new random game
      bot_key = Application.get_env(:pairs_one, :bot_key)

      if bot_key do
        HTTPotion.post(
          "https://api.telegram.org/bot433641023:#{bot_key}/sendMessage?chat_id=@pairsone&text=#{
            new_game_uri
          }"
        )
        |> Map.fetch(:body)
        |> elem(1)
        |> Poison.decode!()
        |> case do
          %{"ok" => true, "result" => %{"message_id" => msg_id}} ->
            Game.save!(game.id, %{game | channel_msg_id: msg_id})

          res ->
            Logger.error("Failed to post to Telegram: #{inspect(res)}")
        end
      else
        Logger.warn("No bot_key set, could not post to Telegram")
      end

      redirect(conn, to: new_game_path)
    end
  end

  defp last_missing_player?(%{players: players}) do
    Enum.count(players, fn p -> p.name == "" end) == 1
  end

  defp missing_players_number(%{players: players}) do
    Enum.count(players, fn p -> p.name == "" end)
  end
end
