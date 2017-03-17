defmodule Cap.Review do
  use Cap.Web, :model

  schema "reviews" do
    field :state, :string
    field :start, :string
    field :stop, :string
    field :continue, :string
    field :start_final, :string
    field :stop_final, :string
    field :continue_final, :string
    field :submitted_at, Ecto.DateTime
    field :finalized_at, Ecto.DateTime
    belongs_to :review_packet, Cap.ReviewPacket
    belongs_to :reviewer, Cap.Reviewer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:start, :stop, :continue, :start_final, :stop_final, :continue_final, :submitted_at, :finalized_at, :state])
    |> validate_required([:state])
  end
end
