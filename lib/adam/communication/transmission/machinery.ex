defmodule Adam.Communication.Transmission.Machinery do
  use Machinery,
    states: [
      "scheduled",
      "performing",
      "transmitted",
      "partial",
      "complete",
      "incomplete",
      "canceled",
      "failure"
    ],
    transitions: %{
      "scheduled" => ["performing", "canceled"],
      "performing" => ["transmitted", "canceled"],
      "transmitted" => ["partial", "complete", "incomplete"],
      "partial" => "complete",
      "incomplete" => ["partial", "complete"],
      "*" => "failure"
    }

  require Logger

  import Adam.Communication, only: [change_transmission: 2]
  import Adam.Information, only: [change_transmission_state: 2]

  alias Adam.Communication.Transmission
  alias Ecto.Multi

  def before_transition(transmission, _next_state) do
    Transmission.load_states(transmission)
  end

  def after_transition(transmission, _next_state) do
    Transmission.load_states(transmission)
  end

  def persist(transmission, next_state) do
    {:ok, %{transmission: transmission}} =
      Multi.new()
      |> Multi.update(:transmission, change_transmission(transmission, %{state: next_state}))
      |> Multi.insert(:state, &add_transmission_state/1)
      |> Adam.Repo.transaction()

    transmission
  end

  def guard_transition(%Transmission{state: state}, next_state) when state == next_state do
    {:error, "The transmission is already #{next_state}."}
  end

  def guard_transition(%Transmission{scheduled_at: scheduled_at} = transmission, "performing") do
    if scheduled_at > NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second) do
      scheduled_at = NaiveDateTime.to_string(scheduled_at)
      message = "Cannot perform because it is scheduled to #{scheduled_at}."

      {:error, message}
    else
      transmission
    end
  end

  def log_transition(%Transmission{id: id} = transmission, next_state) do
    from = "transmission_id: #{id}"
    to = "to: #{next_state}"

    Logger.info("[#{__MODULE__}] Performing state transition of #{from} #{to}")

    transmission
  end

  defp add_transmission_state(%{transmission: transmission}) do
    transmission
    |> Ecto.build_assoc(:states)
    |> change_transmission_state(%{value: transmission.state})
  end
end
