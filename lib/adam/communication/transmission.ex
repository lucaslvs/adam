defmodule Adam.Communication.Transmission do
  use Ecto.Schema

  import Ecto.Changeset

  schema "transmissions" do
    field :label, :string, null: false
    field :state, :string, default: "processed"

    timestamps()
  end

  @doc false
  def changeset(transmission, attrs) do
    transmission
    |> cast(attrs, [:label, :state])
    |> validate_required([:label, :state])
  end
end
