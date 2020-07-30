defmodule Adam.Repo.Migrations.CreateStates do
  use Ecto.Migration

  def change do
    create table(:states) do
      add :value, :string, null: false
      add :transmission_id, references(:transmissions, on_delete: :delete_all)

      timestamps(updated_at: false)
    end

    create index(:states, [:transmission_id])
  end
end
