defmodule PairsOneWeb.GameChannel do
  @moduledoc """
  Receives and broadcasts game state. Uses LZString to compress/decompress JSON data for snappier gameplay over slower Internet.
  """

  use PairsOneWeb.Web, :channel
  alias PairsOne.Game
  alias PairsOneWeb.Presence

  @doc """
  This gets called each time the user loads an existing game (including page reloads). Here we fetch the game from
  storage, join the player to it (it will modify the game and save it back to Redis), and finally, via the :after_join
  callback, broadcast the updated game to other players.
  """
  def join("game:" <> game_id, %{"playerId" => player_id, "playerName" => player_name}, socket) do
    game = Game.get(game_id)
    Game.join_player(game, %{"id" => player_id, "name" => player_name})
    send(self(), :after_join)
    {:ok, assign(socket, :data, %{game_id: game_id, player_id: player_id})}
  end

  @doc """
  This gets called each time some browser sends in a new game (compressed) state. All we do is decompress, save the
  state, update the game in Redis, and then broadcast the compressed state to other players.
  """
  def handle_in("update_game", compressed_game, socket) do
    game = decompress_game(compressed_game)
    Game.save!(socket.assigns.data.game_id, game)
    broadcast_from!(socket, "update_game", %{game: compressed_game})
    {:reply, :ok, socket}
  end

  @doc """
  This gets callde when the user presses "Replay" after they finish a game. Via `Game.replay` we reset the game state
  (e.g. re-generate the board), then compress it and broadcast to other players.
  """
  def handle_in("replay_game", game_data, socket) do
    game = Game.get(socket.assigns.data.game_id) || game_data
    game = Game.replay(game, game_data)
    broadcast!(socket, "update_game", %{game: compress_game(game)})
    {:noreply, socket}
  end

  @doc """
  """
  def handle_in("set_player_name", %{"player_id" => player_id, "name" => name}, socket) do
    game =
      Game.get(socket.assigns.data.game_id)
      |> Game.rename_player(player_id, name)

    broadcast!(socket, "update_game", %{game: compress_game(game)})
    {:noreply, socket}
  end

  @doc """
  """
  def handle_in("new_chat_msg", %{"body" => _body, "player_id" => _player_id} = msg, socket) do
    # TODO: append to chat messages in the game struct
    broadcast!(socket, "new_chat_msg", msg)
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    game_id = socket.assigns.data.game_id
    game = Game.get(game_id)
    broadcast!(socket, "update_game", %{game: compress_game(game)})

    {:ok, _} =
      Presence.track(socket, socket.assigns.data.player_id, %{id: socket.assigns.data.player_id})

    push(socket, "presence_state", Presence.list(socket))

    unless Game.all_players_joined?(game["players"]) do
      PairsOne.PendingGames.add(game_id)
      # PairsOneWeb.Endpoint.broadcast("game-list", "update", pending_games)
    end

    {:noreply, socket}
  end

  defp decompress_game(game) do
    game
    |> Base.decode64!()
    |> LZString.decompress()
    |> Poison.decode!()
  end

  defp compress_game(game) do
    game
    |> Poison.encode!()
    |> LZString.compress()
    |> Base.encode64()
  end

  # defp pending_games do
  #   %{games: PairsOne.PendingGames.data_list()}
  # end
end
