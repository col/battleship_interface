defmodule BattleshipInterface.Router do
  use BattleshipInterface.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BattleshipInterface do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/test", PageController, :test
  end

  # Other scopes may use custom stacks.
  # scope "/api", BattleshipInterface do
  #   pipe_through :api
  # end
end
