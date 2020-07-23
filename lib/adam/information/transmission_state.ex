defmodule Adam.Information.TransmissionState do
  use Ecto.Schema

  import Ecto.Changeset

  alias Adam.Communication.Transmission

  @states [
    "scheduled",
    "performing",
    "transmitted",
    "partial",
    "complete",
    "incomplete",
    "canceled",
    "failure"
  ]

  schema "transmission_states" do
    field :value, :string, null: false

    belongs_to :transmission, Transmission

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(transmission_state, attrs) do
    transmission_state
    |> cast(attrs, [:value])
    |> validate_required([:value])
    |> validate_inclusion(:value, @states)
    |> apply_action!(:insert)
  end
end
