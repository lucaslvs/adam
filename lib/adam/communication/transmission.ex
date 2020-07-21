defmodule Adam.Communication.Transmission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transmissions" do
    field :label, :string, null: false
    field :scheduled_at, :naive_datetime, default: NaiveDateTime.utc_now()
    field :state, :string, null: false

    timestamps()
  end

  @doc false
  def changeset(transmission, attrs) do
    transmission
    |> cast(attrs, [:label, :state, :scheduled_at])
    |> validate_required([:label, :state])
  end
end
