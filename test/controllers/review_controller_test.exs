defmodule Cap.ReviewControllerTest do
  use Cap.ConnCase

  alias Cap.Review
  @valid_attrs %{continue: "some content", continue_final: "some content", finalized_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, start: "some content", start_final: "some content", stop: "some content", stop_final: "some content", submitted_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, state: "some content"}
  @invalid_attrs %{}

  defp create_test_reviews(user) do
    # Create three review packets whose manager is the logged in user
    Enum.each ["first review packet", "second review packet", "third review packet"], fn state -> 
      Repo.insert! %Cap.ReviewPacket{manager_id: user.id, state: state}
    end

    # Create two review packets whose manager is another user
    other_user = Repo.insert! %Cap.User{}
    Enum.each ["fourth review packet", "fifth review packet"], fn state -> 
      Repo.insert! %Cap.ReviewPacket{manager_id: other_user.id, state: state}
    end

    # Create three reviews whose reviewer is the logged in user
    Enum.each ["first review", "second review", "third review"], fn state -> 
      Repo.insert! %Cap.Review{reviewer_id: user.id, state: state}
    end

    # Create two reviews whose reviewer is another user
    other_user = Repo.insert! %Cap.User{}
    Enum.each ["fourth review", "fifth review"], fn state -> 
      Repo.insert! %Cap.Review{reviewer_id: other_user.id, state: state}
    end
  end

  #setup %{conn: conn} do
  #  {:ok, conn: put_req_header(conn, "accept", "application/json")}
  #end

  setup %{conn: conn} do
    # Create a user (bypasses validation)
    user = Repo.insert! %Cap.User{}
    # Encode a token for the user
    { :ok, jwt, _ } = Guardian.encode_and_sign(user, :token)
    
    conn = conn
    |> put_req_header("content-type", "application/vnd.api+json") # JSON-API content-type 
    |> put_req_header("authorization", "Bearer #{jwt}") # Add token to auth header

    {:ok, %{conn: conn, user: user}} # Pass user object to each test
  end

  #test "lists all entries on index", %{conn: conn} do
  #  conn = get conn, review_path(conn, :index)
  #  assert json_response(conn, 200)["data"] == []
  #end

  test "lists all entries on index", %{conn: conn, user: user} do
    # Build test review
    create_test_reviews user
    # List of all reviews
    conn = get conn, review_path(conn, :index)
    assert Enum.count(json_response(conn, 200)["data"]) == 5
  end

  test "lists owned entries on index (manager_id = user id)", %{conn: conn, user: user} do
    # Build test review
    create_test_reviews user
    # List of reviews whose reviewer is user
    conn = get conn, review_path(conn, :index, reviewer_id: user.id)
    assert Enum.count(json_response(conn, 200)["data"]) == 3
  end

  #test "shows chosen resource", %{conn: conn} do
  #  review = Repo.insert! %Review{}
  #  conn = get conn, review_path(conn, :show, review)
  #  assert json_response(conn, 200)["data"] == %{"id" => review.id,
  #    "review_packet_id" => review.review_packet_id,
  #    "reviewer_id" => review.reviewer_id,
  #    "start" => review.start,
  #    "stop" => review.stop,
  #    "continue" => review.continue,
  #    "start_final" => review.start_final,
  #    "stop_final" => review.stop_final,
  #    "continue_final" => review.continue_final,
  #    "submitted_at" => review.submitted_at,
  #    "finalized_at" => review.finalized_at}
  #end

  test "shows chosen resource", %{conn: conn, user: user} do
    review = Repo.insert! %Review{reviewer_id: user.id}
    conn = get conn, review_path(conn, :show, review)
    assert json_response(conn, 200)["data"] == %{
      "id" => to_string(review.id),
      "type" => "review",
      "attributes" => %{
        "state" => review.state,
        "start" => review.start,
        "stop" => review.stop,
        "continue" => review.continue,
        "start-final" => review.start_final,
        "stop-final" => review.stop_final,
        "continue-final" => review.continue_final,
        "submitted-at" => review.submitted_at,
        "finalized-at" => review.finalized_at
      },
      "relationships" => %{
        "reviewer" => %{
          "links" => %{
            "related" => "http://localhost:4001/api/user/#{user.id}"
          }
        }
      }
    }
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, review_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, review_path(conn, :create), review: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Review, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, review_path(conn, :create), review: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, user: user} do
    review = Repo.insert! %Review{reviewer_id: user.id, state: "A review"}
    conn = put conn, review_path(conn, :update, review), review: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Review, @valid_attrs)
  end

  #test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
  #  review = Repo.insert! %Review{reviewer_id: user.id, state: "A review"}
  #  conn = put conn, review_path(conn, :update, review), review: @invalid_attrs
  #  assert json_response(conn, 422)["errors"] != %{}
  #end

  test "deletes chosen resource", %{conn: conn, user: user} do
    review = Repo.insert! %Review{reviewer_id: user.id, state: "A review"}
    conn = delete conn, review_path(conn, :delete, review)
    assert response(conn, 204)
    refute Repo.get(Review, review.id)
  end
end
