defmodule Cap.UserController do
  use Cap.Web, :controller

  alias Cap.User
  plug Guardian.Plug.EnsureAuthenticated, handler: Cap.AuthErrorHandler

  def current(conn, _) do
    user = conn
    |> Guardian.Plug.current_resource

    conn
    |> render(Cap.UserView, "show.json", user: user)
  end
end