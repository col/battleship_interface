defmodule BattleshipInterface.GameChannel do
  use BattleshipInterface.Web, :channel

  alias BattleshipEngine.{GameSupervisor, Game}

  def join("game:"<>_player, _payload, socket) do
    {:ok, socket}
  end

  def handle_in("set_ship_coordinates", payload, socket) do
    %{"player" => player, "ship" => ship, "coordinates" => coordinates} = payload
    player = String.to_atom(player)
    ship = String.to_atom(ship)
    coordinates = Enum.map(coordinates, &(String.to_atom(&1)))
    case Game.set_ship_coordinates({:global, socket.topic}, player, ship, coordinates) do
      :ok -> {:reply, :ok, socket}
      :error -> {:reply, :error, socket}
    end
  end

  def handle_in("set_ships", payload, socket) do
    %{"player" => player} = payload
    player = String.to_atom(player)
    case Game.set_ships({:global, socket.topic}, player) do
      :ok ->
        broadcast! socket, "player_set_ships", %{player: player}
        {:noreply, socket}
      :error ->
        {:reply, :error, socket}
    end
  end

  def handle_in("guess_coordinate", payload, socket) do
    %{"player" => player, "coordinate" => coordinate} = payload
    player = String.to_atom(player)
    coordinate = String.to_atom(coordinate)
    case Game.guess_coordinate({:global, socket.topic}, player, coordinate) do
      {hit, ship, win} ->
        {:reply, {:ok, %{hit: hit, ship: ship, win: win}}, socket}
      :error ->
        {:reply, :error, socket}
    end
  end

end
