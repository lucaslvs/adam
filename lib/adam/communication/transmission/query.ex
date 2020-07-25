defmodule Adam.Communication.Transmission.Query do
  import Ecto.Query, warn: false

  alias Adam.Communication.Transmission

  @doc false
  def filter(attrs) do
    Transmission
    |> order_by(^filter_order_by(attrs["order_by"]))
    |> where(^filter_where(attrs))
  end

  defp filter_order_by("state_desc"), do: [desc: dynamic([t], t.state)]

  defp filter_order_by("state"), do: dynamic([t], t.state)

  defp filter_order_by("label_desc"), do: [desc: dynamic([t], t.label)]

  defp filter_order_by("label"), do: dynamic([t], t.label)

  defp filter_order_by("inserted_at_desc"), do: [desc: dynamic([t], t.inserted_at)]

  defp filter_order_by("inserted_at"), do: dynamic([t], t.inserted_at)

  defp filter_order_by("updated_at_desc"), do: [desc: dynamic([t], t.updated_at)]

  defp filter_order_by("updated_at"), do: dynamic([t], t.updated_at)

  defp filter_order_by("scheduled_at_desc"), do: [desc: dynamic([t], t.scheduled_at)]

  defp filter_order_by("scheduled_at"), do: dynamic([t], t.scheduled_at)

  defp filter_order_by(_), do: []

  defp filter_where(attrs) do
    Enum.reduce(attrs, dynamic(true), fn
      {"label", value}, dynamic ->
        dynamic([t], ^dynamic and t.label == ^value)

      {"scheduled_at", value}, dynamic ->
        dynamic([t], ^dynamic and t.scheduled_at == ^value)

      {"inserted_at", value}, dynamic ->
        dynamic([t], ^dynamic and t.inserted_at > ^value)

      {_, _}, dynamic ->
        dynamic
    end)
  end
end
