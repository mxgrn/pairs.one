defmodule PairsOneWeb.ChatChannel do
  use PairsOneWeb.Web, :channel

  def join("chat:" <> _game_id, _params, socket) do
    {:ok, socket}
  end

  def handle_in("new_msg", _params, socket) do
    {:noreply, socket}
  end
end
