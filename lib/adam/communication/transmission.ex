defmodule Adam.Communication.Transmission do
  use Ecto.Schema

  import Ecto.Changeset

  schema "transmissions" do
    field :label, :string, null: false
    field :scheduled_at, :naive_datetime, null: false
    field :state, :string, default: "scheduled"

    timestamps()
  end

  @doc false
  def changeset(transmission, attrs) do
    transmission
    |> cast(attrs, [:label, :state, :scheduled_at])
    |> validate_required([:label, :state])
    |> put_scheduled_at()
  end

  def to_progress(%__MODULE__{} = transmission) do
    transition_to(transmission, "in_progress")
  end

  def to_cancel(%__MODULE__{} = transmission) do
    transition_to(transmission, "canceled")
  end

  def to_transmit(%__MODULE__{} = transmission) do
    transition_to(transmission, "transmitted")
  end

  def to_partial(%__MODULE__{} = transmission) do
    transition_to(transmission, "partial")
  end

  def to_complete(%__MODULE__{} = transmission) do
    transition_to(transmission, "complete")
  end

  def to_incomplete(%__MODULE__{} = transmission) do
    transition_to(transmission, "incomplete")
  end

  def to_failure(%__MODULE__{} = transmission) do
    transition_to(transmission, "failure")
  end

  defp transition_to(transmission, next_state) when is_binary(next_state) do
    Machinery.transition_to(transmission, __MODULE__.Machinery, next_state)
  end

  defp put_scheduled_at(changeset) do
    case changeset do
      %Ecto.Changeset{changes: %{scheduled_at: _scheduled_at}} ->
        changeset

      %Ecto.Changeset{} ->
        scheduled_at = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
        put_change(changeset, :scheduled_at, scheduled_at)
    end
  end
end
