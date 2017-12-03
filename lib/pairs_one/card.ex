defmodule PairsOne.Card do
  @moduledoc """
  Simply defines single card data struct.
  """
  defstruct value: 0, flipped: false, cleared: false, seen: false
end
