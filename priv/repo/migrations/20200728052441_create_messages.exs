defmodule Adam.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :state, :string, null: false
      add :type, :string, null: false
      add :provider, :string, null: false
      add :sender, :string, null: false
      add :receiver, :string, null: false
      add :transmission_id, references(:transmissions, on_delete: :delete_all)

      timestamps()
    end

    create index(:messages, [:transmission_id])
  end
end
