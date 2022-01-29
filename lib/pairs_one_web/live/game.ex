defmodule PairsOneWeb.Live.Game do
  use PairsOneWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, %{})}
  end

  @impl true
  def handle_event("tile-click", %{"tile_id" => tile_id}, socket) do
    {:noreply, socket |> turn_tile(tile_id)}
  end

  def turn_tile(socket, _tile_id) do
    socket
  end
end
