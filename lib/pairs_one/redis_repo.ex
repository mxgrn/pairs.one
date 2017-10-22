defmodule PairsOne.RedisRepo do
  @moduledoc """
  Starts Redis client and registers a process with passed atom as a name.

  Used in app supervisor.
  """

  def start_link(name, uri) do
    client = Exredis.start_using_connection_string(uri)
    true = Process.register(client, name)
    {:ok, client}
  end
end
