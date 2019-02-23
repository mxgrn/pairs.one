defmodule PairsOne.PendingGames do
  @moduledoc """
  Games started by users who would like to play with a random player
  """
  alias PairsOne.Game

  def start_link() do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def add(id) do
    Agent.get_and_update(__MODULE__, fn ids ->
      if id in ids do
        {false, ids}
      else
        {true, [id | ids]}
      end
    end)
  end

  def remove(id) do
    Agent.get_and_update(__MODULE__, fn ids ->
      if id in ids do
        {true, Enum.filter(ids, &(&1 != id))}
      else
        {false, ids}
      end
    end)
  end

  def index do
    Agent.get(__MODULE__, fn ids -> ids end)
  end

  def data_list do
    Enum.map(index(), fn id ->
      id |> Game.get() |> Game.game_data_for_list()
    end)
  end
end
