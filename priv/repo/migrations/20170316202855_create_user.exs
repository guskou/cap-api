defmodule Cap.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :password_hash, :string
      add :first_name, :string
      add :last_name, :string
      add :anniversary_date, :date
      add :title, :string
      add :manager_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    # Unique email address constraint, via DB index
    create index(:users, [:email], unique: true)

    create index(:users, [:manager_id])

  end
end
