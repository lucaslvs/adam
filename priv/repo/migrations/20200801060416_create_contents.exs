defmodule Adam.Repo.Migrations.CreateContents do
  use Ecto.Migration

  def change do
    create table(:contents) do
      add :name, :string, null: false
      add :value, :string, null: false
      add :transmission_id, references(:transmissions, on_delete: :delete_all)
      add :message_id, references(:messages, on_delete: :delete_all)

      timestamps()
    end

    create index(:contents, [:transmission_id])
    create index(:contents, [:message_id])
    create constraint(:contents, :must_belong_to_transmission_or_message, check: check())
  end

  defp check do
    """
    (transmission_id IS NOT NULL AND message_id IS NULL)
      OR
    (message_id IS NOT NULL AND transmission_id IS NULL)
    """
  end
end
