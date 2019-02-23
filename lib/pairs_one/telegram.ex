defmodule PairsOne.Telegram do
  alias PairsOne.Game
  require Logger

  @doc """
  Notifies Telegram chat on new random game.
  """
  def notify_on_new_game(game, game_url) do
    bot_key = get_telegram_bot_key()

    if bot_key do
      HTTPotion.post(
        "https://api.telegram.org/#{telegram_bot_name()}:#{bot_key}/sendMessage?chat_id=@#{
          get_telegram_chat()
        }&text=#{game_url}"
      )
      |> Map.fetch(:body)
      |> elem(1)
      |> Poison.decode!()
      |> case do
        %{"ok" => true, "result" => %{"message_id" => msg_id}} ->
          Game.save!(game.id, %{game | telegram_msg_id: msg_id})

        res ->
          Logger.error("Failed to post to Telegram: #{inspect(res)}")
      end
    else
      Logger.warn("No Telegram bot_key set")
    end
  end

  @doc """
  Deletes notification from Telegram chat (e.g. when the game is no longer pending).
  """
  def delete_chat_msg(%{"telegram_msg_id" => msg_id}) do
    if get_telegram_bot_key() && msg_id do
      HTTPotion.post(
        "https://api.telegram.org/#{telegram_bot_name()}:#{get_telegram_bot_key()}/deleteMessage?chat_id=@#{
          get_telegram_chat()
        }&message_id=#{msg_id}"
      )
    end
  end

  @doc """
  Telegram's @pairsonebot's auth name
  """
  def telegram_bot_name do
    "bot433641023"
  end

  @doc """
  Telegram's @pairsonebot's auth key
  """
  def get_telegram_bot_key() do
    Application.get_env(:pairs_one, :telegram)[:bot_key]
  end

  @doc """
  Telegram's chat where @pairsonebot posts notifications
  """
  def get_telegram_chat() do
    Application.get_env(:pairs_one, :telegram)[:chat]
  end
end
