defmodule Adam.Communication.Message do
  use Ecto.Schema

  import Ecto.Changeset

  alias Adam.Communication.Transmission
  alias Adam.Information.State
  alias __MODULE__.Query

  @required_fields [:type, :provider, :sender, :receiver]
  @types ["email", "sms"]

  schema "messages" do
    field :provider, :string, null: false
    field :receiver, :string, null: false
    field :sender, :string, null: false
    field :state, :string, default: "pending"
    field :type, :string, null: false

    belongs_to :transmission, Transmission
    has_many :states, State

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, @required_fields ++ [:state])
    |> validate_required(@required_fields)
    |> validate_inclusion(:type, @types)
    |> validate_provider()
  end

  defp validate_provider(changeset) do
    case changeset do
      %Ecto.Changeset{changes: %{type: "email", provider: "sendgrid"}} ->
        changeset

      %Ecto.Changeset{changes: %{type: "sms", provider: "wavy"}} ->
        changeset

      %Ecto.Changeset{changes: %{type: type, provider: provider}} when type in @types ->
        add_error(changeset, :provider, "Cannot send #{type} message with provider #{provider}.")

      changeset ->
        changeset
    end
  end

  @doc false
  def create_changeset(message, attrs) do
    attrs = Map.take(attrs, @required_fields)

    message
    |> changeset(attrs)
    |> add_pending_state()
    |> cast_assoc(:states, with: &State.message_changeset/2, required: true)
  end

  defp add_pending_state(changeset) do
    put_change(changeset, :states, [%{value: "pending"}])
  end

  def filter(attrs), do: Query.filter(attrs)

  def to_send(message), do: transition_to(message, "sending")

  def to_sent(message), do: transition_to(message, "sent")

  def to_delivered(message), do: transition_to(message, "delivered")

  def to_undelivered(message), do: transition_to(message, "undelivered")

  def to_received(message), do: transition_to(message, "received")

  def to_unreceived(message), do: transition_to(message, "unreceived")

  def to_interacted(message), do: transition_to(message, "interacted")

  def to_cancel(message), do: transition_to(message, "canceled")

  def to_failure(message), do: transition_to(message, "failed")

  defp transition_to(%__MODULE__{} = message, next_state) when is_binary(next_state) do
    case Machinery.transition_to(message, __MODULE__.Machinery, next_state) do
      {:ok, %__MODULE__{} = message} ->
        {:ok, message}

      {:error, error_message} ->
        {:error, error_message, message}
    end
  end

  def is_pending?(message), do: with_state?(message, "pending")

  def is_sending?(message), do: with_state?(message, "sending")

  def is_sent?(message), do: with_state?(message, "sent")

  def is_delivered?(message), do: with_state?(message, "delivered")

  def is_undelivered?(message), do: with_state?(message, "undelivered")

  def is_received?(message), do: with_state?(message, "received")

  def is_unreceived?(message), do: with_state?(message, "unreceived")

  def is_interacted?(message), do: with_state?(message, "interacted")

  def is_canceled?(message), do: with_state?(message, "canceled")

  def is_failed?(message), do: with_state?(message, "failed")

  defp with_state?(%__MODULE__{state: current_state}, state) when is_binary(state) do
    current_state == state
  end
end
