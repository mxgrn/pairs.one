defmodule PairsOneWeb.Live.Game.View do
  use Phoenix.HTML
  import Phoenix.LiveView.Helpers

  # import Phoenix.View
  # import PairsOneWeb.Gettext

  alias Phoenix.LiveView.JS

  def card(assigns) do
    ~H"""

    """
  end

  def click_card(number, "clickable") do
    JS.dispatch("pairs:flipped", to: "#card-#{number}")
    |> JS.push("card-click", value: %{number: number})
  end

  def click_card(_, _) do
    %JS{}
  end
end
