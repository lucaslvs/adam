defmodule Adam.Repo.Migrations.CreateTransmissions do
  use Ecto.Migration

  def change do
    create table(:transmissions) do
      add :label, :string, null: false
      add :state, :string, null: false

      timestamps()
    end
  end
end
