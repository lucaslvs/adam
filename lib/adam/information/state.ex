defmodule Adam.Information.State do
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
    "failed"
  ]

  schema "states" do
    field :value, :string, null: false

    belongs_to :transmission, Transmission

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(state, attrs) do
    state
    |> cast(attrs, [:value])
    |> validate_required([:value])
    |> validate_inclusion(:value, @states)
  end

  @doc """
  TODO
  """
  def filter(attrs), do: __MODULE__.Query.filter(attrs)
end
