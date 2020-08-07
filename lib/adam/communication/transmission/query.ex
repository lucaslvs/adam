defmodule Adam.Communication.Transmission.Query do
  import Ecto.Query, warn: false

  alias Adam.Communication.Transmission

  @doc false
  def filter(attrs) do
    Transmission
    |> join(:inner, [t], assoc(t, :messages), as: :messages)
    |> order_by(^filter_order_by(attrs["order_by"]))
    |> where(^filter_where(attrs))
    |> preload([t], ^attrs["preload"])
  end

  defp filter_order_by("label_desc"), do: [desc: dynamic([t], t.label)]

  defp filter_order_by("label"), do: dynamic([t], t.label)

  defp filter_order_by("state_desc"), do: [desc: dynamic([t], t.state)]

  defp filter_order_by("state"), do: dynamic([t], t.state)

  defp filter_order_by("inserted_at_desc"), do: [desc: dynamic([t], t.inserted_at)]

  defp filter_order_by("inserted_at"), do: dynamic([t], t.inserted_at)

  defp filter_order_by("updated_at_desc"), do: [desc: dynamic([t], t.updated_at)]

  defp filter_order_by("updated_at"), do: dynamic([t], t.updated_at)

  defp filter_order_by("scheduled_at_desc"), do: [desc: dynamic([t], t.scheduled_at)]

  defp filter_order_by("scheduled_at"), do: dynamic([t], t.scheduled_at)

  defp filter_order_by("message_provider_desc"), do: [desc: dynamic([messages: m], m.provider)]

  defp filter_order_by("message_provider"), do: dynamic([messages: m], m.provider)

  defp filter_order_by("message_receiver_desc"), do: [desc: dynamic([messages: m], m.receiver)]

  defp filter_order_by("message_receiver"), do: dynamic([messages: m], m.receiver)

  defp filter_order_by("message_sender_desc"), do: [desc: dynamic([messages: m], m.sender)]

  defp filter_order_by("message_sender"), do: dynamic([messages: m], m.sender)

  defp filter_order_by("message_state_desc"), do: [desc: dynamic([messages: m], m.state)]

  defp filter_order_by("message_state"), do: dynamic([messages: m], m.state)

  defp filter_order_by("message_type_desc"), do: [desc: dynamic([messages: m], m.type)]

  defp filter_order_by("message_type"), do: dynamic([messages: m], m.type)

  defp filter_order_by("message_inserted_at_desc"),
    do: [desc: dynamic([messages: m], m.inserted_at)]

  defp filter_order_by("message_inserted_at"), do: dynamic([messages: m], m.inserted_at)

  defp filter_order_by("message_updated_at_desc"),
    do: [desc: dynamic([messages: m], m.updated_at)]

  defp filter_order_by("message_updated_at"), do: dynamic([messages: m], m.updated_at)

  defp filter_order_by(_), do: []

  defp filter_where(attrs) do
    Enum.reduce(attrs, dynamic(true), fn
      {"label", value}, dynamic ->
        dynamic([t], ^dynamic and t.label == ^value)

      {"state", value}, dynamic ->
        dynamic([t], ^dynamic and t.state == ^value)

      {"inserted_at", value}, dynamic ->
        dynamic([t], ^dynamic and t.inserted_at == ^value)

      {"updated_at", value}, dynamic ->
        dynamic([t], ^dynamic and t.updated_at == ^value)

      {"scheduled_at", value}, dynamic ->
        dynamic([t], ^dynamic and t.scheduled_at == ^value)

      {"message_provider", value}, dynamic ->
        dynamic([messages: m], ^dynamic and m.provider == ^value)

      {"message_receiver", value}, dynamic ->
        dynamic([messages: m], ^dynamic and m.receiver == ^value)

      {"message_sender", value}, dynamic ->
        dynamic([messages: m], ^dynamic and m.sender == ^value)

      {"message_state", value}, dynamic ->
        dynamic([messages: m], ^dynamic and m.state == ^value)

      {"message_type", value}, dynamic ->
        dynamic([messages: m], ^dynamic and m.type == ^value)

      {"message_inserted_at", value}, dynamic ->
        dynamic([messages: m], ^dynamic and m.inserted_at == ^value)

      {"message_updated_at", value}, dynamic ->
        dynamic([messages: m], ^dynamic and m.updated_at == ^value)

      {_, _}, dynamic ->
        dynamic
    end)
  end
end
