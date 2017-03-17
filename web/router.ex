defmodule Cap.Router do
  use Cap.Web, :router

  # Unauthenticated Requests
  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  # Authenticated Requests
  pipeline :api_auth do
    plug :accepts, ["json", "json-api"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", Cap do
    pipe_through :api
    # Registration
    post "/register", RegistrationController, :create
    # Login
    post "/token", SessionController, :create, as: :login
  end

  scope "/api", Cap do
    pipe_through :api_auth
    get "/user/current", UserController, :current, as: :current_user
    resources "/user", UserController, only: [:show, :index] do
      get "/review_packets", ReviewPacketController, :index, as: :review_packets
      get "/reviews", ReviewController, :index, as: :reviews
    end
    resources "/review_packets", ReviewPacketController, except: [:new, :edit]
    resources "/reviews", ReviewController, except: [:new, :edit]
  end
end