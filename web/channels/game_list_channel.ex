defmodule PairsOne.GameListChannel do
  @moduledoc """
  Handles list of active and pending games
  """

  use PairsOne.Web, :channel

  alias PairsOne.Game

  def join("game-list", _params, socket) do
    send(self, :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    # games  = PairsOne.Games.index
    #   |> Enum.map(&game_data/1)

    # active_games  = PairsOne.ActiveGames.index
    #   |> Enum.map(&game_data/1)


    push socket, "update", %{"games" => PairsOne.PendingGames.data_list}
    # push socket, "list_active_games", %{"games" => active_games}
    {:noreply, socket}
  end
end

