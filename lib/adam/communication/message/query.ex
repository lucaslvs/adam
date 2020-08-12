defmodule Adam.Communication.Message.Query do
  @moduledoc false

  import Ecto.Query, warn: false

  alias Adam.Communication.Message

  @doc false
  def filter(attrs) do
    Message
    |> join(:inner, [m], assoc(m, :transmission), as: :transmission)
    |> order_by(^filter_order_by(attrs["order_by"]))
    |> where(^filter_where(attrs))
    |> preload([m], ^attrs["preload"])
  end

  defp filter_order_by("provider_desc"), do: [desc: dynamic([m], m.provider)]

  defp filter_order_by("provider"), do: dynamic([m], m.provider)

  defp filter_order_by("receiver_desc"), do: [desc: dynamic([m], m.receiver)]

  defp filter_order_by("receiver"), do: dynamic([m], m.receiver)

  defp filter_order_by("sender_desc"), do: [desc: dynamic([m], m.sender)]

  defp filter_order_by("sender"), do: dynamic([m], m.sender)

  defp filter_order_by("state_desc"), do: [desc: dynamic([m], m.state)]

  defp filter_order_by("state"), do: dynamic([m], m.state)

  defp filter_order_by("type_desc"), do: [desc: dynamic([m], m.type)]

  defp filter_order_by("type"), do: dynamic([m], m.type)

  defp filter_order_by("inserted_at_desc"), do: [desc: dynamic([m], m.inserted_at)]

  defp filter_order_by("inserted_at"), do: dynamic([m], m.inserted_at)

  defp filter_order_by("updated_at_desc"), do: [desc: dynamic([m], m.updated_at)]

  defp filter_order_by("updated_at"), do: dynamic([m], m.updated_at)

  defp filter_order_by("transmission_id_desc"), do: [desc: dynamic([m], m.transmission_id)]

  defp filter_order_by("transmission_id"), do: dynamic([m], m.transmission_id)

  defp filter_order_by("transmission_label_desc"), do: [desc: dynamic([transmission: t], t.label)]

  defp filter_order_by("transmission_label"), do: dynamic([transmission: t], t.label)

  defp filter_order_by("transmission_state_desc"), do: [desc: dynamic([transmission: t], t.state)]

  defp filter_order_by("transmission_state"), do: dynamic([transmission: t], t.state)

  defp filter_order_by("transmission_inserted_at_desc"),
    do: [desc: dynamic([transmission: t], t.inserted_at)]

  defp filter_order_by("transmission_inserted_at"), do: dynamic([transmission: t], t.inserted_at)

  defp filter_order_by("transmission_updated_at_desc"),
    do: [desc: dynamic([transmission: t], t.updated_at)]

  defp filter_order_by("transmission_updated_at"), do: dynamic([transmission: t], t.updated_at)

  defp filter_order_by("transmission_scheduled_at_desc"),
    do: [desc: dynamic([transmission: t], t.scheduled_at)]

  defp filter_order_by("transmission_scheduled_at"),
    do: dynamic([transmission: t], t.scheduled_at)

  defp filter_order_by(_), do: []

  defp filter_where(attrs) do
    Enum.reduce(attrs, dynamic(true), fn
      {"provider", value}, dynamic ->
        dynamic([m], ^dynamic and m.provider == ^value)

      {"receiver", value}, dynamic ->
        dynamic([m], ^dynamic and m.receiver == ^value)

      {"sender", value}, dynamic ->
        dynamic([m], ^dynamic and m.sender == ^value)

      {"state", value}, dynamic ->
        dynamic([m], ^dynamic and m.state == ^value)

      {"type", value}, dynamic ->
        dynamic([m], ^dynamic and m.type == ^value)

      {"inserted_at", value}, dynamic ->
        dynamic([m], ^dynamic and m.inserted_at == ^value)

      {"updated_at", value}, dynamic ->
        dynamic([m], ^dynamic and m.updated_at == ^value)

      {"transmission_id", value}, dynamic ->
        dynamic([m], ^dynamic and m.transmission_id == ^value)

      {"transmission_label", value}, dynamic ->
        dynamic([transmission: t], ^dynamic and t.label == ^value)

      {"transmission_state", value}, dynamic ->
        dynamic([transmission: t], ^dynamic and t.state == ^value)

      {"transmission_inserted_at", value}, dynamic ->
        dynamic([transmission: t], ^dynamic and t.inserted_at == ^value)

      {"transmission_updated_at", value}, dynamic ->
        dynamic([transmission: t], ^dynamic and t.updated_at == ^value)

      {"transmission_scheduled_at", value}, dynamic ->
        dynamic([transmission: t], ^dynamic and t.scheduled_at == ^value)

      {_, _}, dynamic ->
        dynamic
    end)
  end
end
