defmodule PairsOne.Theme do
  @moduledoc """
  Game themes-related data and operations
  """

  @themes [
    eighties: %{
      folder: "eighties",
      title: "Eighties",
      cards: 40
    },

    animals: %{
      folder: "animals",
      title: "Animals",
      cards: 50
    },

    animals_2: %{
      folder: "animals2",
      title: "Animals 2",
      cards: 50
    },

    pokemon: %{
      folder: "pokemon",
      title: "Pokémon",
      cards: 50
    },

    halloween: %{
      folder: "halloween",
      title: "Halloween",
      cards: 48
    },

    fairy_tails: %{
      folder: "fairy-tails",
      title: "Fairy Tails",
      cards: 50
    },

    music: %{
      folder: "music",
      title: "Music",
      cards: 50
    },

    owls: %{
      folder: "owls",
      title: "Owls b/w",
      cards: 50
    },

    cats: %{
      folder: "cats",
      title: "Cats b/w",
      cards: 50
    }

  ]

  @doc """
  Given theme name, returns number of cards in that theme
  """
  def cards_number(name) when is_binary(name) do
    @themes[String.to_atom(name)].cards
  end

  @doc """
  Return theme data by name
  """
  def get(name) when is_binary(name) do
    themes[String.to_atom(name)]
  end

  @doc """
  Accessor to themes map
  """
  def themes do
    @themes
  end

  @doc """
  Themes as a list
  """
  def list do
    @themes |> Enum.map(fn {theme, data} -> Map.merge(data, %{name: theme}) end)
  end
end
