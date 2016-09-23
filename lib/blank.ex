defmodule Blank do
  @moduledoc """
  Tools around checking and handling undefined or blank data.
  """

  @doc """
  Returns `true` if data is considered blank/empty.
  """
  def blank?(data) do
    Blank.Protocol.blank?(data)
  end

  @doc """
  Returns `true` if data is not considered blank/empty.
  """
  def present?(data) do
    !blank?(data)
  end

  @doc """
  Returns the provided `data` if valid of the `default` value if not.
  """
  def default_to(data, default) do
    if blank?(data), do: default, else: data
  end
end

defprotocol Blank.Protocol do
  @moduledoc """
  Provides only one single method definition `blank?/1`
  """

  @doc """
  Returns `true` if data is considered blank/empty.
  """
  def blank?(data)
end

# Integers are never blank
defimpl Blank.Protocol, for: Integer do
  def blank?(_), do: false
end

defimpl Blank.Protocol, for: BitString do
  def blank?(""), do: true
  def blank?(_), do: false
end

# Just empty list is blank
defimpl Blank.Protocol, for: List do
  def blank?([]), do: true
  def blank?(_), do: false
end

defimpl Blank.Protocol, for: Map do
  # Keep in mind we could not pattern match on %{} because
  # it matches on all maps. We can however check if the size
  # is zero (and size is a fast operation).
  def blank?(map), do: map_size(map) == 0
end

# Just the atoms false and nil are blank
defimpl Blank.Protocol, for: Atom do
  def blank?(false), do: true
  def blank?(nil), do: true
  def blank?(_), do: false
end
