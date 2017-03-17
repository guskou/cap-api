defmodule Cap.ReviewTest do
  use Cap.ModelCase

  alias Cap.Review

  #@valid_attrs %{continue: "some content", continue_final: "some content", finalized_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, start: "some content", start_final: "some content", stop: "some content", stop_final: "some content", submitted_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}}
  @valid_attrs %{continue: "some content", continue_final: "some content", start: "some content", start_final: "some content", stop: "some content", stop_final: "some content", state: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Review.changeset(%Review{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Review.changeset(%Review{}, @invalid_attrs)
    refute changeset.valid?
  end
end
