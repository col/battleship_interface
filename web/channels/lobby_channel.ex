defmodule BattleshipInterface.LobbyChannel do
  use BattleshipInterface.Web, :channel

  alias BattleshipEngine.{GameSupervisor, Game}

  def join("lobby", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("open_games", _payload, socket) do
    open_games = GameSupervisor.list_open_games(GameSupervisor)
    {:reply, {:ok, %{"games": open_games}}, socket}
  end

  def handle_in("new_game", payload, socket) do
    IO.puts "New Game Payload #{inspect payload}"
    %{"player" => player} = payload
    case GameSupervisor.start_game(player) do
      {:ok, _pid} ->
        {:reply, {:ok, %{"game": "game:"<>player}}, socket}
      {:error, reason} ->
        {:reply, {:error, %{reason: inspect(reason)}}, socket}
    end
  end

  def handle_in("join_game", payload, socket) do
    %{"game" => game, "player" => player} = payload
    case Game.add_player({:global, game}, player) do
      :ok ->
        BattleshipInterface.Endpoint.broadcast! game, "player_added", %{message: "New player just joined: "<>player}
        {:reply, :ok, socket}
      {:error, reason} ->
        {:reply, {:error, %{reason: reason}}, socket}
    end
  end

end
