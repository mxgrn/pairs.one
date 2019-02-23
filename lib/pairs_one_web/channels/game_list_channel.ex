defmodule PairsOneWeb.GameListChannel do
  @moduledoc """
  Handles list of active and pending games.
  NOTE: currently not used.
  """

  use PairsOneWeb.Web, :channel

  def join("game-list", _params, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    push(socket, "update", %{"games" => PairsOne.PendingGames.data_list()})
    {:noreply, socket}
  end
end
