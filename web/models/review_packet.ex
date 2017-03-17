defmodule Cap.ReviewPacket do
  use Cap.Web, :model

  schema "review_packets" do
    field :review_period, :string
    field :state, :string
    field :started_at, Ecto.DateTime
    field :finalized_at, Ecto.DateTime
    field :signed_at, Ecto.DateTime
    belongs_to :user, Cap.User
    belongs_to :manager, Cap.Manager

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:review_period, :state, :started_at, :finalized_at, :signed_at])
    |> validate_required([:review_period, :state])
  end
end
