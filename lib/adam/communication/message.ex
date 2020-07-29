defmodule Adam.Communication.Message do
  use Ecto.Schema

  import Ecto.Changeset

  alias Adam.Communication.Transmission

  @required_fields [:type, :provider, :sender, :receiver]
  @types ["email", "sms"]

  schema "messages" do
    field :provider, :string, null: false
    field :receiver, :string, null: false
    field :sender, :string, null: false
    field :state, :string, default: "pending"
    field :type, :string, null: false

    belongs_to :transmission, Transmission

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
  end

  defp add_pending_state(changeset) do
    put_change(changeset, :states, [%{value: "pending"}])
  end
end
