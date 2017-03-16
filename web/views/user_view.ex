defmodule Cap.UserView do
  use Cap.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Cap.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Cap.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      "type": "user",
      "id": user.id,
      "attributes": %{
        "email": user.email
      }
    }
  end
end