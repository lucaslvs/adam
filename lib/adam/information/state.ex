defmodule Adam.Information.State do
  use Ecto.Schema

  import Ecto.Changeset

  alias Adam.Communication.{Transmission, Message}

  @shared_states ["canceled", "failed"]

  @transmission_states [
    "scheduled",
    "performing",
    "transmitted",
    "partial",
    "complete",
    "incomplete"
  ]

  @message_states [
    "pending",
    "sending",
    "sent",
    "delivered",
    "undelivered",
    "received",
    "unreceived",
    "interacted"
  ]

  schema "states" do
    field :value, :string, null: false

    belongs_to :transmission, Transmission
    belongs_to :message, Message

    timestamps(updated_at: false)
  end

  @doc false
  def transmission_changeset(state, attrs) do
    state
    |> changeset(attrs)
    |> validate_inclusion(:value, @shared_states ++ @transmission_states)
    |> assoc_constraint(:transmission)
    |> must_belong_to_transmission_or_message(:transmission)
  end

  @doc false
  def message_changeset(state, attrs) do
    state
    |> changeset(attrs)
    |> validate_inclusion(:value, @shared_states ++ @message_states)
    |> assoc_constraint(:message)
    |> must_belong_to_transmission_or_message(:message)
  end

  defp changeset(state, attrs) do
    state
    |> cast(attrs, [:value, :transmission_id, :message_id])
    |> validate_required([:value])
  end

  defp must_belong_to_transmission_or_message(changeset, field)
       when field in [:transmission, :message] do
    check_constraint(
      changeset,
      field,
      name: :must_belong_to_transmission_or_message,
      message: "Must belong to a transmission or a message"
    )
  end

  @doc """
  TODO
  """
  def filter(attrs), do: __MODULE__.Query.filter(attrs)
end
