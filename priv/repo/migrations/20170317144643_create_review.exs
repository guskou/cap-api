defmodule Cap.Repo.Migrations.CreateReview do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :state, :string
      add :start, :string
      add :stop, :string
      add :continue, :string
      add :start_final, :string
      add :stop_final, :string
      add :continue_final, :string
      add :submitted_at, :utc_datetime
      add :finalized_at, :utc_datetime
      add :review_packet_id, references(:review_packets, on_delete: :nothing)
      add :reviewer_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:reviews, [:review_packet_id])
    create index(:reviews, [:reviewer_id])

  end
end
