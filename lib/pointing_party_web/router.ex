defmodule PointingPartyWeb.Router do
  use PointingPartyWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", PointingPartyWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/join", JoinController, :join)

    get("/new", PartyController, :new)
    post("/create", PartyController, :create)

    get("/signin", UserController, :signin)
    post("/connect", UserController, :connect)

    get("/show", PartyController, :show)

    get("/:id", JoinController, :new)

    get("/.well-known/acme-challenge/:id", ChallengeController, :show)
  end

  # Other scopes may use custom stacks.
  # scope "/api", PointingPartyWeb do
  #   pipe_through :api
  # end
end
