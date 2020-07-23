defmodule Adam.Communication.Transmission do
  use Ecto.Schema

  import Ecto.Changeset

  alias Adam.Information.TransmissionState

  schema "transmissions" do
    field :label, :string, null: false
    field :scheduled_at, :naive_datetime, null: false
    field :state, :string, default: "scheduled"

    has_many :states, TransmissionState

    timestamps()
  end

  @doc false
  def changeset(transmission, attrs) do
    transmission
    |> cast(attrs, [:label, :state, :scheduled_at])
    |> validate_required([:label])
    |> maybe_schedule_for_now()
  end

  @doc false
  def create_changeset(transmission, attrs) do
    transmission
    |> changeset(Map.take(attrs, [:label, :scheduled_at]))
    |> add_scheduled_state()
    |> cast_assoc(:states, with: &TransmissionState.changeset/2, required: true)
  end

  @doc false
  def load_states(%__MODULE__{} = transmission) do
    Adam.Repo.preload(transmission, :states)
  end

  def to_perform(transmission) do
    transition_to(transmission, "performing")
  end

  def to_cancel(transmission) do
    transition_to(transmission, "canceled")
  end

  def to_transmit(transmission) do
    transition_to(transmission, "transmitted")
  end

  def to_partial(transmission) do
    transition_to(transmission, "partial")
  end

  def to_complete(transmission) do
    transition_to(transmission, "complete")
  end

  def to_incomplete(transmission) do
    transition_to(transmission, "incomplete")
  end

  def to_failure(transmission) do
    transition_to(transmission, "failure")
  end

  defp transition_to(%__MODULE__{} = transmission, next_state) when is_binary(next_state) do
    case Machinery.transition_to(transmission, __MODULE__.Machinery, next_state) do
      {:error, message} ->
        {:error, message, transmission}

      result ->
        result
    end
  end

  defp maybe_schedule_for_now(changeset) do
    case changeset do
      %Ecto.Changeset{changes: %{scheduled_at: _scheduled_at}} ->
        changeset

      %Ecto.Changeset{} ->
        scheduled_at = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
        put_change(changeset, :scheduled_at, scheduled_at)
    end
  end

  defp add_scheduled_state(changeset) do
    put_change(changeset, :states, [%{value: "scheduled"}])
  end
end
