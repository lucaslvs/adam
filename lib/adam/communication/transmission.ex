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
    attrs = Map.take(attrs, [:label, :scheduled_at])

    transmission
    |> changeset(attrs)
    |> add_scheduled_state()
    |> cast_assoc(:states, with: &TransmissionState.changeset/2, required: true)
  end

  @doc """
  TODO
  """
  def filter(attrs), do: __MODULE__.Query.filter(attrs)

  @doc """
  TODO
  """
  def to_perform(transmission) do
    transition_to(transmission, "performing")
  end

  @doc """
  TODO
  """
  def to_cancel(transmission) do
    transition_to(transmission, "canceled")
  end

  @doc """
  TODO
  """
  def to_transmit(transmission) do
    transition_to(transmission, "transmitted")
  end

  @doc """
  TODO
  """
  def to_partial(transmission) do
    transition_to(transmission, "partial")
  end

  @doc """
  TODO
  """
  def to_complete(transmission) do
    transition_to(transmission, "complete")
  end

  @doc """
  TODO
  """
  def to_incomplete(transmission) do
    transition_to(transmission, "incomplete")
  end

  @doc """
  TODO
  """
  def to_failure(transmission) do
    transition_to(transmission, "failed")
  end

  @doc """
  TODO
  """
  def is_scheduled?(transmission), do: with_state?(transmission, "scheduled")

  @doc """
  TODO
  """
  def is_performing?(transmission), do: with_state?(transmission, "performing")

  @doc """
  TODO
  """
  def is_canceled?(transmission), do: with_state?(transmission, "canceled")

  @doc """
  TODO
  """
  def is_transmitted?(transmission), do: with_state?(transmission, "transmitted")

  @doc """
  TODO
  """
  def is_partial?(transmission), do: with_state?(transmission, "partial")

  @doc """
  TODO
  """
  def is_complete?(transmission), do: with_state?(transmission, "complete")

  @doc """
  TODO
  """
  def is_incomplete?(transmission), do: with_state?(transmission, "incomplete")

  @doc """
  TODO
  """
  def is_failed?(transmission), do: with_state?(transmission, "failed")

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

  defp transition_to(%__MODULE__{} = transmission, next_state) when is_binary(next_state) do
    case Machinery.transition_to(transmission, __MODULE__.Machinery, next_state) do
      {:error, message} ->
        {:error, message, transmission}

      result ->
        result
    end
  end

  defp with_state?(%__MODULE__{state: current_state}, state) when is_binary(state) do
    current_state == state
  end
end
