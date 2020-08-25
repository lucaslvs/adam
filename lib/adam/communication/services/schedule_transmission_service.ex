defmodule Adam.Communication.ScheduleTransmissionService do
  use Adam, :service

  alias Adam.Communication.{Transmission, Message}
  alias Adam.Information.State

  parameter(:label, from: "label", type: :string)
  parameter(:scheduled_at, from: "scheduled_at", type: :string, required: false)
  parameter(:contents, from: "contents", type: :map)

  parameter(:messages,
    from: "messages",
    list_item: %{
      inner: %{
        provider: %{type: :string, required: false, from: "provider"},
        receiver: %{type: :string, from: "receiver"},
        sender: %{type: :string, from: "sender"},
        type: %{type: :string, from: "type"},
        contents: %{type: :map, from: "contents"}
      }
    }
  )

  @impl Exop.Operation
  def process(parameters) do
    Transmission
    |> struct!()
    |> validate_parameters(parameters)
    |> Repo.insert()
  end

  defp validate_parameters(transmission, parameters) do
    transmission
    |> build_transmission_changeset(parameters)
    |> add_scheduled_state()
    |> validate_states()
    |> validate_messages()
  end

  defp build_transmission_changeset(transmission, parameters) do
    permitted_parameters = take_permitted_parameters(parameters)

    Transmission.changeset(transmission, permitted_parameters)
  end

  defp take_permitted_parameters(parameters) do
    permitted_parameters = [:label, :scheduled_at, :messages, :contents]
    permitted_parameters = permitted_parameters ++ Enum.map(permitted_parameters, &to_string/1)

    Map.take(parameters, permitted_parameters)
  end

  defp add_scheduled_state(changeset) do
    put_change(changeset, :states, [%{value: "scheduled"}])
  end

  defp validate_states(changeset) do
    cast_assoc(changeset, :states, with: &State.transmission_changeset/2, required: true)
  end

  defp validate_messages(changeset) do
    cast_assoc(changeset, :messages, with: &Message.create_changeset/2, required: true)
  end
end
