defmodule PairsOne.Player do
  @moduledoc """
  Simply defines player data struct.
  """
  defstruct id: "",
            name: "Player 1",
            joined: false,
            online: false,
            score: 0,
            totalScore: 0,
            turns: 0,
            inaccurateTurns: 0
end
