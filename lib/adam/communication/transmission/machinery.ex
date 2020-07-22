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

  alias Adam.Communication
  alias Adam.Communication.Transmission

  def persist(transmission, next_state) do
    {:ok, transmission} = Communication.update_transmission(transmission, %{state: next_state})

    transmission
  end

  def guard_transition(%Transmission{scheduled_at: scheduled_at} = transmission, "performing") do
    if scheduled_at > NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second) do
      scheduled_at = NaiveDateTime.to_string(scheduled_at)
      message = "Cannot perform because it is scheduled to #{scheduled_at}"

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
end
