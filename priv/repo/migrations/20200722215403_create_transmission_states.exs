defmodule Adam.Repo.Migrations.CreateTransmissionStates do
  use Ecto.Migration

  def change do
    create table(:transmission_states) do
      add :value, :string, null: false
      add :transmission_id, references(:transmissions, on_delete: :delete_all)

      timestamps(updated_at: false)
    end

    create index(:transmission_states, [:transmission_id])
  end
end
