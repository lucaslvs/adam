defmodule Adam.Information.CreateTransmissionStateService do
  use Exop.Operation

  import Adam.Factory

  alias Adam.{Communication, Repo}
  alias Adam.Communication.Transmission
  alias Adam.Information.State
  alias Ecto.Multi

  @states [
    "scheduled",
    "performing",
    "transmitted",
    "partial",
    "complete",
    "incomplete",
    "canceled",
    "failed"
  ]

  parameter(:transmission, from: "transmission", struct: Transmission)
  parameter(:state, from: "state", type: :string, in: @states)

  @impl Exop.Operation
  def process(%{transmission: transmission, state: state}) do
    Multi.new()
    |> update_transmission(transmission, state)
    |> create_transmission_state()
    |> perform_transaction()
  end

  defp update_transmission(multi, transmission, state) do
    Multi.update(multi, :transmission, transmission_changeset(transmission, state))
  end

  defp transmission_changeset(transmission, next_state) do
    Communication.change_transmission(transmission, Map.new(state: next_state))
  end

  defp create_transmission_state(multi) do
    Multi.insert(multi, :state, &build_transmission_state/1)
  end

  defp build_transmission_state(%{transmission: %Transmission{state: state} = transmission}) do
    :transmission_state
    |> build(transmission: transmission)
    |> State.transmission_changeset(%{value: state})
  end

  defp perform_transaction(multi) do
    case Repo.transaction(multi) do
      {:ok, %{transmission: transmission}} ->
        transmission

      transaction_result ->
        transaction_result
    end
  end
end
