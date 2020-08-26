defmodule Adam.Communication.ScheduleTransmissionService do
  use Adam, :service

  alias Adam.Communication.{Content, Transmission, Message}
  alias Adam.Information.State

  @scheduled_at_format ~r/(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/

  parameter(:label, from: "label", type: :string)
  parameter(:contents, from: "contents", type: :map)

  parameter(:scheduled_at,
    from: "scheduled_at",
    type: :string,
    required: false,
    func: &__MODULE__.validate_scheduled_at/2
  )

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

  @doc false
  def validate_scheduled_at({:scheduled_at, value}, _parameters) do
    unless is_valid_scheduled_at(value) do
      {:error, "not valid, the valid format is year-mouth-day hours:minutes:seconds"}
    end
  end

  defp is_valid_scheduled_at(value), do: Regex.match?(@scheduled_at_format, value)

  defp validate_parameters(transmission, parameters) do
    transmission
    |> build_transmission_changeset(parameters)
    |> add_scheduled_transmission_state()
    |> validate_transmission_states()
    |> validate_messages()
  end

  defp build_transmission_changeset(transmission, parameters) do
    permitted_parameters =
      parameters
      |> take_permitted_parameters()
      |> normalize_scheduled_at()

    Transmission.changeset(transmission, permitted_parameters)
  end

  defp take_permitted_parameters(parameters) do
    parameters
    |> maybe_transform_contents_parameter()
    |> Map.take([:label, :scheduled_at, :messages, :contents])
  end

  defp maybe_transform_contents_parameter(parameters) do
    case parameters do
      %{contents: contents} when is_map(contents) ->
        Map.put(parameters, :contents, Content.transform_parameters(contents))

      parameters ->
        parameters
    end
  end

  defp normalize_scheduled_at(parameters) do
    scheduled_at =
      case parameters do
        %{scheduled_at: scheduled_at} ->
          transform_scheduled_at(scheduled_at)

        _parameters ->
          NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
      end

    Map.put(parameters, :scheduled_at, scheduled_at)
  end

  defp transform_scheduled_at(scheduled_at) do
    case NaiveDateTime.from_iso8601(scheduled_at) do
      {:ok, naive_date_time} ->
        NaiveDateTime.truncate(naive_date_time, :second)

      {:error, :invalid_format} ->
        interrupt(Map.new(scheduled_at: "invalid format"))

      {:error, :invalid_date} ->
        interrupt(Map.new(scheduled_at: "invalid date"))
    end
  end

  defp add_scheduled_transmission_state(changeset) do
    scheduled_state_parameters = [value: "scheduled"] |> Map.new() |> List.wrap()

    put_change(changeset, :states, scheduled_state_parameters)
  end

  defp validate_transmission_states(changeset) do
    cast_assoc(changeset, :states, with: &State.transmission_changeset/2, required: true)
  end

  defp validate_messages(changeset) do
    cast_assoc(changeset, :messages, with: &Message.create_changeset/2, required: true)
  end
end
