defmodule PairsOneWeb.ChatChannel do
  use PairsOneWeb.Web, :channel

  def join("chat:" <> game_id, params, socket) do
    {:ok, socket}
  end

  def handle_in("new_msg", params, socket) do
    {:noreply, socket}
  end
end
