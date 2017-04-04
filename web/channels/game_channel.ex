defmodule BattleshipInterface.GameChannel do
  use BattleshipInterface.Web, :channel

  alias BattleshipEngine.Game

  def join("game:"<>_player, _payload, socket) do
    {:ok, socket}
  end

  def handle_in("hello", payload, socket) do
    # {:reply, {:ok, payload}, socket}
    # {:reply, {:error, %{reason: "We force this error"}}, socket}
    # push socket, "said_hello", payload
    broadcast! socket, "said_hello", payload
    {:noreply, socket}
  end

  def handle_in("new_game", _payload, socket) do
    "game:"<>player = socket.topic
    case Game.start_link(player) do
      {:ok, _pid} ->
        {:reply, :ok, socket}
      {:error, reason} ->
        {:reply, {:error, %{reason: inspect(reason)}}, socket}
    end
  end

  def handle_in("add_player", player, socket) do
    case Game.add_player({:global, socket.topic}, player) do
      :ok ->
        broadcast! socket, "player_added", %{message: "New player just joined: "<>player}
        {:noreply, socket}
      {:error, reason} ->
        {:reply, {:error, %{reason: reason}}, socket}
    end
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

  def handle_in("set_ships", player, socket) do
    player = String.to_atom(player)
    case Game.set_ships({:global, socket.topic}, player) do
      :ok ->
        broadcast! socket, "player_set_ships", %{player: player}
        {:noreply, socket}
      :error ->
        {:reply, :error, socket}
    end
  end

end
