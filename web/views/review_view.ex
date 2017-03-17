defmodule Cap.ReviewView do
  use Cap.Web, :view
  use JaSerializer.PhoenixView

  attributes [:state, :start, :stop, :continue, :start_final, :stop_final, :continue_final, :submitted_at, :finalized_at]
  has_one :reviewer, link: :user_link

  def user_link(review, conn) do
    user_url(conn, :show, review.reviewer_id)
  end

  def render("index.json", %{reviews: reviews}) do
    %{data: render_many(reviews, Cap.ReviewView, "review.json")}
  end

  def render("show.json", %{review: review}) do
    %{data: render_one(review, Cap.ReviewView, "review.json")}
  end

  def render("review.json", %{review: review}) do
    %{id: review.id,
      review_packet_id: review.review_packet_id,
      reviewer_id: review.reviewer_id,
      state: review.state,
      start: review.start,
      stop: review.stop,
      continue: review.continue,
      start_final: review.start_final,
      stop_final: review.stop_final,
      continue_final: review.continue_final,
      submitted_at: review.submitted_at,
      finalized_at: review.finalized_at}
  end
end
