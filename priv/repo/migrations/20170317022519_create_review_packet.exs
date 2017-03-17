defmodule Cap.Repo.Migrations.CreateReviewPacket do
  use Ecto.Migration

  def change do
    create table(:review_packets) do
      add :review_period, :string
      add :state, :string
      add :started_at, :utc_datetime
      add :finalized_at, :utc_datetime
      add :signed_at, :utc_datetime
      add :user_id, references(:users, on_delete: :nothing)
      add :manager_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:review_packets, [:user_id])
    create index(:review_packets, [:manager_id])

  end
end
