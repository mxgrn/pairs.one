defmodule PairsOne.GameChannel do
  @moduledoc """
  Receives and broadcasts game state. Uses LZString to compress/decompress JSON data for snappier gameplay over slower Internet.
  """
  use PairsOne.Web, :channel
  alias PairsOne.Game

  @doc """
  This gets called each time the user loads an existing game (including page reloads). Here we fetch the game from
  storage, join the player to it (it will modify the game and save it back to Redis), and finally, via the :after_join
  callback, broadcast the updated game to other players.
  """
  def join("game:" <> game_id, %{"playerId" => player_id, "playerName" => player_name} , socket) do
    game = Game.get(game_id)
    Game.join_player(game, %{"id" => player_id, "name" => player_name})
    res = assign(socket, :game_id, game_id)
    send(self, :after_join)
    {:ok, res}
  end

  @doc """
  This gets called each time some browser sends in a new game (compressed) state. All we do is decompress, the state,
  update the game in Redis, and then broadcast the compressed state to other players.
  """
  def handle_in("update_game", compressed_game, socket) do
    Game.save!(socket.assigns.game_id, decompress_game(compressed_game))
    broadcast_from! socket, "update_game", %{game: compressed_game}
    {:reply, :ok, socket}
  end

  @doc """
  This gets callde when the user presses "Replay" after they finish a game. Via `Game.replay` we reset the game state
  (e.g. re-generate the board), then compress it and broadcast to other players.
  """
  def handle_in("replay_game", game_data, socket) do
    game = Game.get(socket.assigns.game_id) || game_data
    game = Game.replay(game, game_data)
    broadcast! socket, "update_game", %{game: compress_game(game)}
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    game = Game.get(socket.assigns.game_id)
    broadcast! socket, "update_game", %{game: compress_game(game)}
    {:noreply, socket}
  end

  defp decompress_game(game) do
    game
    |> Base.decode64!
    |> LZString.decompress
    |> Poison.decode!
  end

  defp compress_game(game) do
    game
    |> Poison.encode!
    |> LZString.compress
    |> Base.encode64
  end
end
