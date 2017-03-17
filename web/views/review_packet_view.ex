defmodule Cap.ReviewPacketView do
  use Cap.Web, :view
  use JaSerializer.PhoenixView

  attributes [:review_period, :state, :started_at, :finalized_at, :signed_at]
  has_one :manager, link: :user_link

  def user_link(review_packet, conn) do
    user_url(conn, :show, review_packet.manager_id)
  end

  def render("index.json", %{review_packets: review_packets}) do
    %{data: render_many(review_packets, Cap.ReviewPacketView, "review_packet.json")}
  end

  def render("show.json", %{review_packet: review_packet}) do
    %{data: render_one(review_packet, Cap.ReviewPacketView, "review_packet.json")}
  end

  def render("review_packet.json", %{review_packet: review_packet}) do
    %{id: review_packet.id,
      user_id: review_packet.user_id,
      manager_id: review_packet.manager_id,
      review_period: review_packet.review_period,
      state: review_packet.state,
      started_at: review_packet.started_at,
      finalized_at: review_packet.finalized_at,
      signed_at: review_packet.signed_at}
  end
end
