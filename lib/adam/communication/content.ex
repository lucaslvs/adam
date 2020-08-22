defmodule Adam.Communication.Content do
  use Ecto.Schema

  import Ecto.Changeset

  alias Adam.Communication.{Transmission, Message}

  schema "contents" do
    field :name, :string, null: false
    field :value, :string, null: false

    belongs_to :transmission, Transmission
    belongs_to :message, Message

    timestamps()
  end

  @doc false
  def transmission_changeset(content, attrs) do
    content
    |> changeset(attrs)
    |> assoc_constraint(:transmission)
    |> must_belong_to_transmission_or_message(:transmission)
  end

  @doc false
  def message_changeset(content, attrs) do
    content
    |> changeset(attrs)
    |> assoc_constraint(:message)
    |> must_belong_to_transmission_or_message(:message)
  end

  defp changeset(content, attrs) do
    content
    |> cast(attrs, [:name, :value])
    |> validate_required([:name, :value])
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

  def transform_in_attributes(attrs) when is_map(attrs) do
    Enum.map(attrs, fn
      {name, value} when is_atom(name) ->
        Map.new(name: to_string(name), value: value)

      {name, value} ->
        Map.new(name: name, value: value)
    end)
  end
end
