defmodule PairsOneWeb.Live.Game.View do
  use Phoenix.HTML
  import Phoenix.LiveView.Helpers

  # import Phoenix.View
  # import PairsOneWeb.Gettext

  alias Phoenix.LiveView.JS

  def card_ids(game) do
    game["cards"]["values"]
  end

  def image_path(game, card_id) do
    "/images/#{game["theme"]}/#{card_id}.svg"
  end

  def state_class(game, index) do
    cond do
      Enum.member?(game["cards"]["cleared"], index) -> "cleared"
      Enum.member?(game["cards"]["flipped"], index) -> "flipped"
      true -> "clickable"
    end
  end

  def card(assigns) do
    ~H"""

    """
  end

  def click_card(game, index) do
    if state_class(game, index) == "clickable" do
      JS.dispatch("pairs:flipped", to: "#card-#{index}")
      |> JS.push("card-click", value: %{index: index})
    else
      %JS{}
    end
  end
end
