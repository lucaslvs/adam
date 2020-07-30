defmodule Adam.Repo.Migrations.AddMessageIdFkInStates do
  use Ecto.Migration

  def change do
    alter table(:states) do
      add :message_id, references(:messages, on: :delete_all)
    end

    create index(:states, [:message_id])
    create constraint(:states, :must_belong_to_transmission_or_message, check: check())
  end

  defp check do
    """
    (transmission_id IS NOT NULL AND message_id IS NULL)
      OR
    (message_id IS NOT NULL AND transmission_id IS NULL)
    """
  end
end
