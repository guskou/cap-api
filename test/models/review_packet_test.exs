defmodule Cap.ReviewPacketTest do
  use Cap.ModelCase

  alias Cap.ReviewPacket

  #@valid_attrs %{finalized_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, review_period: "some content", signed_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, started_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, state: "some content"}
  @valid_attrs %{review_period: "some content", state: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ReviewPacket.changeset(%ReviewPacket{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ReviewPacket.changeset(%ReviewPacket{}, @invalid_attrs)
    refute changeset.valid?
  end
end
