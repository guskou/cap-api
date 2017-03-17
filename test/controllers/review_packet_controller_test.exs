defmodule Cap.ReviewPacketControllerTest do
  use Cap.ConnCase

  alias Cap.ReviewPacket
  @valid_attrs %{finalized_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, review_period: "some content", signed_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, started_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, state: "some content"}
  @invalid_attrs %{}

  defp create_test_review_packets(user) do
    # Create three review packets whose manager is the logged in user
    Enum.each ["first review packet", "second review packet", "third review packet"], fn state -> 
      Repo.insert! %Cap.ReviewPacket{manager_id: user.id, state: state}
    end

    # Create two review packets whose manager is another user
    other_user = Repo.insert! %Cap.User{}
    Enum.each ["fourth review packet", "fifth review packet"], fn state -> 
      Repo.insert! %Cap.ReviewPacket{manager_id: other_user.id, state: state}
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
  #  conn = get conn, review_packet_path(conn, :index)
  #  assert json_response(conn, 200)["data"] == []
  #end

  test "lists all entries on index", %{conn: conn, user: user} do
    # Build test review packets
    create_test_review_packets user
    # List of all review packets
    conn = get conn, review_packet_path(conn, :index)
    assert Enum.count(json_response(conn, 200)["data"]) == 5
  end

  test "lists owned entries on index (manager_id = user id)", %{conn: conn, user: user} do
    # Build test review packets
    create_test_review_packets user
    # List of review packets whose manager is user
    conn = get conn, review_packet_path(conn, :index, manager_id: user.id)
    assert Enum.count(json_response(conn, 200)["data"]) == 3
  end

  #test "shows chosen resource", %{conn: conn} do
  #  review_packet = Repo.insert! %ReviewPacket{}
  #  conn = get conn, review_packet_path(conn, :show, review_packet)
  #  assert json_response(conn, 200)["data"] == %{"id" => review_packet.id,
  #    "user_id" => review_packet.user_id,
  #    "manager_id" => review_packet.manager_id,
  #    "review_period" => review_packet.review_period,
  #    "state" => review_packet.state,
  #    "started_at" => review_packet.started_at,
  #    "finalized_at" => review_packet.finalized_at,
  #    "signed_at" => review_packet.signed_at}
  #end

  test "shows chosen resource", %{conn: conn, user: user} do
    review_packet = Repo.insert! %ReviewPacket{manager_id: user.id}
    conn = get conn, review_packet_path(conn, :show, review_packet)
    assert json_response(conn, 200)["data"] == %{
      "id" => to_string(review_packet.id),
      "type" => "review-packet",
      "attributes" => %{
        "review-period" => review_packet.review_period,
        "state" => review_packet.state,
        "started-at" => review_packet.started_at,
        "finalized-at" => review_packet.finalized_at,
        "signed-at" => review_packet.signed_at
      },
      "relationships" => %{
        "manager" => %{
          "links" => %{
            "related" => "http://localhost:4001/api/user/#{user.id}"
          }
        }
      }
    }
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, review_packet_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, review_packet_path(conn, :create), review_packet: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ReviewPacket, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, review_packet_path(conn, :create), review_packet: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, user: user} do
    review_packet = Repo.insert! %ReviewPacket{manager_id: user.id, state: "A review packet"}
    conn = put conn, review_packet_path(conn, :update, review_packet), review_packet: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ReviewPacket, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
    review_packet = Repo.insert! %ReviewPacket{manager_id: user.id, state: "A review packet"}
    conn = put conn, review_packet_path(conn, :update, review_packet), review_packet: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, user: user} do
    review_packet = Repo.insert! %ReviewPacket{manager_id: user.id, state: "A review packet"}
    conn = delete conn, review_packet_path(conn, :delete, review_packet)
    assert response(conn, 204)
    refute Repo.get(ReviewPacket, review_packet.id)
  end
end
