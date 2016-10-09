defmodule PairsOne.ActiveGames do
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
end
