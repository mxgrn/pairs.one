defmodule PairsOne.RedisRepo do
  @moduledoc """
  Starts Redis client and registers a process with passed atom as a name.

  Used in app supervisor.
  """

  require Logger

  def start_link(_uri) do
    uri = Application.get_env(:pairs_one, :redis_uri)
    Logger.info("Starting Redis client with URI: #{uri}")

    client = Exredis.start_using_connection_string(uri)
    true = Process.register(client, :redis)
    {:ok, client}
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end
end
