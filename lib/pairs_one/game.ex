defmodule PairsOne.Game do
  @moduledoc """
  Game persistence with Redis.

  Note that currently the board can only be a square (n*n, not n*m).
  It would require a minor refactoring to remove this limitation.
  """

  alias PairsOne.Theme
  alias PairsOne.Telegram
  alias Exredis.Api, as: Redis

  defstruct id: "",
            cards: %{cleared: [], flipped: [], seen: [], values: []},
            players: [],
            theme: "eighties",
            flips: 2,
            turn: -1,
            visibility: "public",
            random: false,
            telegram_msg_id: nil

  @redis_prefix "game:"

  @doc """
  Fetch persisted game by its id
  """
  def get(id) do
    id |> get_json |> Poison.decode!()
  end

  @doc """
  Check whether game with given id is persisted
  """
  def exists?(id) do
    Redis.exists(:redis, "#{@redis_prefix}#{id}") == 1
  end

  @doc """
  Create and returns new game given its params
  """
  def create(%{
        "board_size" => board_size,
        "players_number" => players_number,
        "theme" => theme_name,
        "visibility" => visibility,
        "random" => random
      }) do
    players_number = String.to_integer(players_number)
    board_size = String.to_integer(board_size)

    id = UUID.uuid4() |> String.split("-") |> List.last()

    local? = visibility == "local"

    players =
      0..(players_number - 1)
      |> Enum.map(fn _ -> %PairsOne.Player{id: "", name: "", joined: local?, online: local?} end)

    turn =
      if local? do
        0
      else
        -1
      end

    game = %PairsOne.Game{
      id: id,
      cards: cards(board_size, Theme.cards_number(theme_name)),
      players: players,
      theme: theme_name,
      visibility: visibility,
      random: random,
      turn: turn
    }

    save!(id, game)

    game
  end

  @doc """
  Save game with provided id
  """
  def save!(id, game) do
    {:ok, game_string} = Poison.encode(game)
    Redis.setex(:redis, "#{@redis_prefix}#{id}", 24 * 60 * 60, game_string)
    game
  end

  @doc """
  Given new params, reset completed game
  """
  def replay(game, %{"theme" => theme_name}) do
    players =
      Enum.map(game["players"], fn player ->
        %{player | "score" => 0, "turns" => 0, "inaccurateTurns" => 0}
      end)

    theme = Theme.get(theme_name)

    cards =
      game["cards"]["values"]
      |> length
      |> :math.sqrt()
      |> round
      |> cards(theme.cards)

    game = %{game | "cards" => cards, "players" => players, "theme" => theme_name}

    save!(game["id"], game)
  end

  @doc """
  Given player id and game, try to join the player to the game:
  1) If player is already in the game (which happens when the user reloads the page), return that player.
  2) If player is new, try to find a vacant slot.
  3) Otherwise return nil.
  """
  def join_player(game, %{"id" => id, "name" => _} = player) do
    index = player_index(game["players"], id)
    join_player_at(game, index, player)
  end

  def rename_player(game, player_id, name) do
    new_players =
      game["players"]
      |> Enum.map(fn p -> if p["id"] == player_id, do: %{p | "name" => name}, else: p end)

    %{game | "players" => new_players}
  end

  # Return list of shuffled cards on the board, given board size and number of cards in the theme
  defp cards(board_size, cards_number) do
    card_values = Enum.take_random(1..cards_number, trunc(board_size * board_size / 2))
    double_values = card_values ++ card_values
    values = double_values |> Enum.shuffle()

    %{
      values: values,
      flipped: [],
      cleared: [],
      seen: []
    }
  end

  # Do not join player at a given index if the index is nil
  defp join_player_at(_, nil, _) do
  end

  # Join player at a given index
  defp join_player_at(game, index, player) do
    players = game["players"]

    player_overrides = %{
      "id" => player["id"],
      "name" => player["name"],
      "joined" => true,
      "online" => true
    }

    player = Map.merge(Enum.at(players, index), player_overrides)

    players = List.replace_at(players, index, player)

    game = %{game | "players" => players}

    game = set_turn(game)

    save!(game["id"], game)

    if game["telegram_msg_id"] && all_players_joined?(players) do
      Telegram.delete_chat_msg(game)
      save!(game["id"], %{game | "telegram_msg_id" => nil})
    end

    player
  end

  # Set initial game turn if all players have joined
  defp set_turn(%{"turn" => -1, "players" => players} = game) do
    turn =
      if all_players_joined?(players) do
        0
      else
        -1
      end

    %{game | "turn" => turn}
  end

  # Do not change turn if the game is running already
  defp set_turn(game) do
    game
  end

  # Check whether all players in the game have "joined" status
  def all_players_joined?(players) do
    Enum.all?(players, fn p -> p["joined"] end)
  end

  def any_player_online?(game) do
    Enum.any?(game["players"], fn p -> p["online"] end)
  end

  def game_data_for_list(game) do
    playerJson = fn player ->
      %{name: player["name"]}
    end

    size = length(game["cards"]["values"]) |> :math.sqrt() |> round

    %{
      id: game["id"],
      theme: game["theme"],
      size: "#{size}x#{size}",
      players: Enum.map(game["players"], playerJson)
    }
  end

  def update_players_online_state(game, presences) do
    new_players =
      Enum.map(game["players"], fn player ->
        online? = Enum.any?(presences, fn {player_id, _} -> player["id"] == player_id end)

        %{player | "online" => online?}
      end)

    save!(game["id"], %{game | "players" => new_players})
  end

  # Given player id, try to find at what index to join the player
  defp player_index(players, player_id) do
    ok? = fn player ->
      player["id"] == player_id || not player["joined"]
    end

    Enum.find_index(players, ok?)
  end

  # Given game's id, fetches game's JSON from Redis
  defp get_json(id) do
    game_string = Redis.get(:redis, "#{@redis_prefix}#{id}")

    if game_string == :undefined do
      ""
    else
      game_string
    end
  end
end
