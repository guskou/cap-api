defmodule Cap.ReviewPacketController do
  use Cap.Web, :controller

  alias Cap.ReviewPacket
  plug Guardian.Plug.EnsureAuthenticated, handler: Cap.AuthErrorHandler

  #def index(conn, _params) do
  #  review_packets = Repo.all(ReviewPacket)
  #  render(conn, "index.json", review_packets: review_packets)
  #end

  # List of review packets by manager
  def index(conn, %{"manager_id" => manager_id}) do
    review_packets = ReviewPacket
    |> where(manager_id: ^manager_id)
    |> Repo.all
    
    render(conn, "index.json-api", data: review_packets)
  end

  # Full list of review packets
  def index(conn, _params) do
    review_packets = Repo.all(ReviewPacket)
    render(conn, "index.json-api", data: review_packets)
  end

  def create(conn, %{"review_packet" => review_packet_params}) do
    # Get the current user
    current_user = Guardian.Plug.current_resource(conn)
    # Build the current user's ID into the changeset
    changeset = ReviewPacket.changeset(%ReviewPacket{manager_id: current_user.id}, review_packet_params)

    case Repo.insert(changeset) do
      {:ok, review_packet} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", review_packet_path(conn, :show, review_packet))
        |> render("show.json-api", data: review_packet)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Cap.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    review_packet = Repo.get!(ReviewPacket, id)
    render(conn, "show.json-api", data: review_packet)
  end

  def update(conn, %{"id" => id, "review_packet" => review_packet_params}) do
    current_user = Guardian.Plug.current_resource(conn)

    #review_packet = Repo.get!(ReviewPacket, id)
    review_packet = ReviewPacket
    |> where(manager_id: ^current_user.id, id: ^id)
    |> Repo.one!

    changeset = ReviewPacket.changeset(review_packet, review_packet_params)

    case Repo.update(changeset) do
      {:ok, review_packet} ->
        render(conn, "show.json-api", data: review_packet)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Cap.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)
    
    #review_packet = Repo.get!(ReviewPacket, id)
    review_packet = ReviewPacket
    |> where(manager_id: ^current_user.id, id: ^id)
    |> Repo.one!

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(review_packet)

    send_resp(conn, :no_content, "")
  end
end
