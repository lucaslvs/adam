defmodule Adam.Communication.Transmission do
  @moduledoc """
  TODO
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Adam.Communication.{Content, Message}
  alias Adam.Information.State
  alias __MODULE__.Query

  @typedoc "The transmission entity"
  @type transmission :: Transmission.t()

  schema "transmissions" do
    field :label, :string, null: false
    field :scheduled_at, :naive_datetime, null: false
    field :state, :string, default: "scheduled"

    has_many :states, State
    has_many :messages, Message
    has_many :contents, Content

    timestamps()
  end

  @doc false
  @spec changeset(transmission(), map()) :: Ecto.Changeset.t()
  def changeset(transmission, attrs) do
    transmission
    |> cast(maybe_transform_contents_attributes(attrs), [:label, :state, :scheduled_at])
    |> validate_required([:label])
    |> maybe_schedule_for_now()
  end

  defp maybe_transform_contents_attributes(attrs) do
    case attrs do
      %{contents: contents} when is_map(contents) ->
        Map.put(attrs, :contents, Content.transform_in_attributes(contents))

      %{"contents" => contents} when is_map(contents) ->
        Map.put(attrs, "contents", Content.transform_in_attributes(contents))

      attrs ->
        attrs
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

  @doc false
  @spec create_changeset(transmission(), map()) :: Ecto.Changeset.t()
  def create_changeset(transmission, attrs) do
    transmission
    |> changeset(take_creation_permitted_attributes(attrs))
    |> add_scheduled_state()
    |> cast_assoc(:states, with: &State.transmission_changeset/2, required: true)
    |> cast_assoc(:messages, with: &Message.create_changeset/2, required: true)
  end

  defp take_creation_permitted_attributes(attrs) do
    Map.take(attrs, [
      :label,
      :scheduled_at,
      :messages,
      :contents,
      "label",
      "scheduled_at",
      "messages",
      "contents"
    ])
  end

  defp add_scheduled_state(changeset) do
    put_change(changeset, :states, [%{value: "scheduled"}])
  end

  @doc """
  TODO
  """
  @spec filter(nil | maybe_improper_list() | map()) :: Ecto.Query.t()
  def filter(attrs), do: Query.filter(attrs)

  @doc """
  TODO
  """
  @spec to_perform(transmission()) :: {:ok, transmission()} | {:error, binary(), transmission()}
  def to_perform(transmission), do: transition_to(transmission, "performing")

  @doc """
  TODO
  """
  @spec to_transmit(transmission()) :: {:ok, transmission()} | {:error, binary(), transmission()}
  def to_transmit(transmission), do: transition_to(transmission, "transmitted")

  @doc """
  TODO
  """
  @spec to_partial(transmission()) :: {:ok, transmission()} | {:error, binary(), transmission()}
  def to_partial(transmission), do: transition_to(transmission, "partial")

  @doc """
  TODO
  """
  @spec to_complete(transmission()) :: {:ok, transmission()} | {:error, binary(), transmission()}
  def to_complete(transmission), do: transition_to(transmission, "complete")

  @doc """
  TODO
  """
  @spec to_incomplete(transmission()) ::
          {:ok, transmission()} | {:error, binary(), transmission()}
  def to_incomplete(transmission), do: transition_to(transmission, "incomplete")

  @doc """
  TODO
  """
  @spec to_cancel(transmission()) :: {:ok, transmission()} | {:error, binary(), transmission()}
  def to_cancel(transmission), do: transition_to(transmission, "canceled")

  @doc """
  TODO
  """
  @spec to_failure(transmission()) :: {:ok, transmission()} | {:error, binary(), transmission()}
  def to_failure(transmission), do: transition_to(transmission, "failed")

  defp transition_to(%__MODULE__{} = transmission, next_state) when is_binary(next_state) do
    case Machinery.transition_to(transmission, __MODULE__.Machinery, next_state) do
      {:ok, %__MODULE__{} = transmission} ->
        {:ok, transmission}

      {:error, error_message} ->
        {:error, error_message, transmission}
    end
  end

  @doc """
  TODO
  """
  @spec is_scheduled?(transmission()) :: boolean()
  def is_scheduled?(transmission), do: with_state?(transmission, "scheduled")

  @doc """
  TODO
  """
  @spec is_performing?(transmission()) :: boolean()
  def is_performing?(transmission), do: with_state?(transmission, "performing")

  @doc """
  TODO
  """
  @spec is_canceled?(transmission()) :: boolean()
  def is_canceled?(transmission), do: with_state?(transmission, "canceled")

  @doc """
  TODO
  """
  @spec is_transmitted?(transmission()) :: boolean()
  def is_transmitted?(transmission), do: with_state?(transmission, "transmitted")

  @doc """
  TODO
  """
  @spec is_partial?(transmission()) :: boolean()
  def is_partial?(transmission), do: with_state?(transmission, "partial")

  @doc """
  TODO
  """
  @spec is_complete?(transmission()) :: boolean()
  def is_complete?(transmission), do: with_state?(transmission, "complete")

  @doc """
  TODO
  """
  @spec is_incomplete?(transmission()) :: boolean()
  def is_incomplete?(transmission), do: with_state?(transmission, "incomplete")

  @doc """
  TODO
  """
  @spec is_failed?(transmission()) :: boolean()
  def is_failed?(transmission), do: with_state?(transmission, "failed")

  defp with_state?(%__MODULE__{state: current_state}, state) when is_binary(state) do
    current_state == state
  end
end
