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

end
