defmodule PairsOneWeb.Live.Game do
  use PairsOneWeb, :live_view

  import PairsOneWeb.Live.Game.View

  alias PairsOne.Game
  alias PairsOneWeb.Endpoint
  # alias PairsOneWeb.Presence

  @impl true
  def mount(_params, %{"id" => game_id}, socket) do
    if Game.exists?(game_id) do
      Endpoint.subscribe("game:#{game_id}")

      game = Game.get(game_id)
      player_id = 1
      Game.join_player(game, %{"id" => player_id, "name" => "Toni"})

      send(self(), :after_join)

      {:ok, assign(socket, game_id: game_id, game: game, player_id: player_id)}
    else
      {:ok, socket}
    end
  end

  @impl true
  def handle_event("card-click", %{"index" => index}, socket) do
    game =
      Game.get(socket.assigns.game_id)
      |> Game.flip(index)

    Endpoint.broadcast!(topic(socket), "update_game", %{game: compress_game(game)})

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "update_game", payload: %{game: compressed_game}}, socket) do
    game = decompress_game(compressed_game)
    Game.save!(socket.assigns.game_id, game)
    {:noreply, socket |> assign(:game, game)}
  end

  @impl true
  def handle_info(%{event: "replay_game", payload: game_data}, socket) do
    game = Game.get(socket.assigns.game_id) || game_data
    game = Game.replay(game, game_data)
    Endpoint.broadcast!(topic(socket), "update_game", %{game: compress_game(game)})
    {:noreply, socket}
  end

  @impl true
  def handle_info(
        %{event: "set_player_name", payload: %{"player_id" => player_id, "name" => name}},
        socket
      ) do
    game =
      Game.get(socket.assigns.game_id)
      |> Game.rename_player(player_id, name)

    Endpoint.broadcast!(topic(socket), "update_game", %{game: compress_game(game)})
    {:noreply, socket}
  end

  @impl true
  def handle_info(
        %{event: "new_chat_msg", payload: %{"body" => _body, "player_id" => _player_id} = msg},
        socket
      ) do
    # TODO: append to chat messages in the game struct
    Endpoint.broadcast!(topic(socket), "new_chat_msg", msg)
    {:noreply, socket}
  end

  @impl true
  def handle_info(:after_join, socket) do
    game_id = socket.assigns.game_id
    game = Game.get(game_id)

    # Endpoint.broadcast!(topic(socket), "update_game", %{game: compress_game(game)})

    # {:ok, _} =
    #   Presence.track(socket, socket.assigns.data.player_id, %{id: socket.assigns.data.player_id})

    # Endpoint.push(socket, "presence_state", Presence.list(socket))

    unless Game.all_players_joined?(game["players"]) do
      PairsOne.PendingGames.add(game_id)
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

  defp topic(socket) do
    "game:#{socket.assigns.game_id}"
  end
end
