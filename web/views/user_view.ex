defmodule Cap.UserView do
  use Cap.Web, :view
  use JaSerializer.PhoenixView

  attributes [:email]
  has_many :review_packets, link: :review_packets_link

  def review_packets_link(user, conn) do
    user_review_packets_url(conn, :index, user.id)
  end

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