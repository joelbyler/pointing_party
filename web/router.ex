defmodule PointingParty.Router do
  use PointingParty.Web, :router

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

  scope "/", PointingParty do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/new", PageController, :new
    post "/create", PageController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", PointingParty do
  #   pipe_through :api
  # end
end
