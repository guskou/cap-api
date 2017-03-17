defmodule Cap.ReviewController do
  use Cap.Web, :controller

  alias Cap.Review
  plug Guardian.Plug.EnsureAuthenticated, handler: Cap.AuthErrorHandler

  #def index(conn, _params) do
  #  reviews = Repo.all(Review)
  #  render(conn, "index.json", reviews: reviews)
  #end

  # List of reviews by reviewer
  def index(conn, %{"reviewer_id" => reviewer_id}) do
    reviews = Review
    |> where(reviewer_id: ^reviewer_id)
    |> Repo.all
    
    render(conn, "index.json-api", data: reviews)
  end

  # Full list of reviews
  def index(conn, _params) do
    reviews = Repo.all(Review)
    render(conn, "index.json-api", data: reviews)
  end

  def create(conn, %{"review" => review_params}) do
    # Get the current user
    current_user = Guardian.Plug.current_resource(conn)
    # Build the current user's ID into the changeset
    changeset = Review.changeset(%Review{reviewer_id: current_user.id}, review_params)

    case Repo.insert(changeset) do
      {:ok, review} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", review_path(conn, :show, review))
        |> render("show.json-api", data: review)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Cap.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    review = Repo.get!(Review, id)
    render(conn, "show.json-api", data: review)
  end

  def update(conn, %{"id" => id, "review" => review_params}) do
    current_user = Guardian.Plug.current_resource(conn)

    #review = Repo.get!(Review, id)
    review = Review
    |> where(reviewer_id: ^current_user.id, id: ^id)
    |> Repo.one!

    changeset = Review.changeset(review, review_params)

    case Repo.update(changeset) do
      {:ok, review} ->
        render(conn, "show.json-api", data: review)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Cap.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)

    #review = Repo.get!(Review, id)
    review = Review
    |> where(reviewer_id: ^current_user.id, id: ^id)
    |> Repo.one!

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(review)

    send_resp(conn, :no_content, "")
  end
end
