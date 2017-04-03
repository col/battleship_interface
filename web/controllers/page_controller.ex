defmodule BattleshipInterface.PageController do
  use BattleshipInterface.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
