defmodule PairsOneWeb.Live.Game do
  use PairsOneWeb, :live_view

  import PairsOneWeb.Live.Game.View

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket, %{
       cards: %{
         "1" => {"clickable", "/images/owls/11.svg", 0},
         "2" => {"clickable", "/images/owls/12.svg", 0},
         "3" => {"clickable", "/images/owls/22.svg", 0},
         "4" => {"clickable", "/images/owls/6.svg", 0},
         "5" => {"clickable", "/images/owls/13.svg", 0},
         "6" => {"clickable", "/images/owls/8.svg", 0},
         "7" => {"clickable", "/images/owls/9.svg", 0},
         "8" => {"clickable", "/images/owls/22.svg", 0},
         "9" => {"clickable", "/images/owls/7.svg", 0},
         "10" => {"clickable", "/images/owls/9.svg", 0},
         "11" => {"clickable", "/images/owls/12.svg", 0},
         "12" => {"clickable", "/images/owls/13.svg", 0},
         "13" => {"clickable", "/images/owls/6.svg", 0},
         "14" => {"clickable", "/images/owls/7.svg", 0},
         "15" => {"clickable", "/images/owls/8.svg", 0},
         "16" => {"clickable", "/images/owls/11.svg", 0}
       },
       flip_count: 0
     })}
  end

  @impl true
  def handle_event("card-click", %{"number" => number}, socket) do
    {:noreply, socket |> update_card_state(number, "flipped") |> update_game()}
  end

  def update_game(%{assigns: %{cards: cards}} = socket) do
    flipped =
      Enum.filter(cards, fn {_, {state, _, _}} -> state == "flipped" end)
      |> Enum.sort_by(fn {_, {_, _, n}} -> n end)

    case Enum.count(flipped) do
      0 ->
        socket

      1 ->
        socket

      2 ->
        [{first_n, {_, first_image, _}}, {second_n, {_, second_image, _}}] = flipped

        if first_image == second_image do
          socket
          |> update_card_state(first_n, "cleared")
          |> update_card_state(second_n, "cleared")
        else
          socket
        end

      _ ->
        [{first_n, {_, first_image, _}}, {second_n, {_, second_image, _}} | _] = flipped

        if first_image == second_image do
          socket
          |> update_card_state(first_n, "cleared")
          |> update_card_state(second_n, "cleared")
        else
          socket
          |> update_card_state(first_n, "clickable")
          |> update_card_state(second_n, "clickable")
        end
    end
  end

  def update_card_state(socket, number, state) do
    {_state, image, _flip_count} = Map.get(socket.assigns.cards, number)

    flip_count =
      if state do
        socket.assigns.flip_count + 1
      else
        socket.assigns.flip_count
      end

    cards = Map.put(socket.assigns.cards, number, {state, image, flip_count})

    assign(socket, %{cards: cards, flip_count: flip_count})
  end
end
