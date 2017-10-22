defmodule PairsOne.ChatChannel do
  use PairsOne.Web, :channel

  def join("chat:" <> game_id, params, socket) do
    import Logger; Logger.info ~s(\n\n!!! game_id: #{inspect game_id}\n)
    {:ok, socket}
  end

  def handle_in("new_msg", params, socket) do
    import Logger; Logger.info ~s(\n\n!!! params: #{inspect params}\n)
    {:noreply, socket}
  end
end
