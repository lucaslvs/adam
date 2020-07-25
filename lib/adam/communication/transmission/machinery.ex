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
  alias Adam.Information

  def before_transition(%Transmission{id: id}, _next_state) do
    Communication.get_transmission!(id)
  end

  def after_transition(%Transmission{id: id}, _next_state) do
    id
    |> Communication.get_transmission!()
    |> Information.load_states()
  end

  def persist(transmission, next_state) do
    {:ok, %{transmission: transmission}} =
      Information.create_transmission_state(transmission, next_state)

    transmission
  end

  def guard_transition(transmission, "performing") do
    if scheduled_time_is_now?(transmission) do
      scheduled_at = NaiveDateTime.to_string(transmission.scheduled_at)

      {:error, "Cannot perform because it is scheduled to #{scheduled_at}."}
    else
      transmission
    end
  end

  def guard_transition(%Transmission{state: state}, next_state) when state == next_state do
    {:error, "The transmission is already #{next_state}."}
  end

  def guard_transition(transmission, next_state) do
    if Information.transmission_already_had_in?(transmission, next_state) do
      {:error, "The transmission already had in #{next_state}."}
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

  defp scheduled_time_is_now?(%Transmission{scheduled_at: scheduled_at}) do
    scheduled_at > NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
  end
end
