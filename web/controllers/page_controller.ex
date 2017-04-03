defmodule BattleshipInterface.PageController do
  use BattleshipInterface.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def test(conn, %{"name" => name}) do
    {:ok, _pid} = BattleshipEngine.Game.start_link(name)
    conn
    |> put_flash(:info, "You entered the name: " <> name)
    |> render("index.html")
  end

end
