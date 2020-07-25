defmodule Adam.Information.TransmissionState.Query do
  import Ecto.Query, warn: false

  alias Adam.Information.TransmissionState

  @doc false
  def filter(attrs) do
    TransmissionState
    |> order_by(^filter_order_by(attrs["order_by"]))
    |> where(^filter_where(attrs))
  end

  defp filter_order_by("transmission_id_desc"), do: [desc: dynamic([ts], ts.transmission_id)]

  defp filter_order_by("transmission_id"), do: dynamic([ts], ts.transmission_id)

  defp filter_order_by("value_desc"), do: [desc: dynamic([ts], ts.value)]

  defp filter_order_by("value"), do: dynamic([ts], ts.value)

  defp filter_order_by("inserted_at_desc"), do: [desc: dynamic([ts], ts.inserted_at)]

  defp filter_order_by("inserted_at"), do: dynamic([ts], ts.inserted_at)

  defp filter_order_by(_), do: []

  defp filter_where(attrs) do
    Enum.reduce(attrs, dynamic(true), fn
      {"transmission_id", value}, dynamic ->
        dynamic([ts], ^dynamic and ts.transmission_id == ^value)

      {"value", value}, dynamic ->
        dynamic([ts], ^dynamic and ts.value == ^value)

      {"inserted_at", value}, dynamic ->
        dynamic([ts], ^dynamic and ts.inserted_at > ^value)

      {_, _}, dynamic ->
        dynamic
    end)
  end
end
