defmodule Adam.Communication.Transmission.Machinery do
  @moduledoc false

  use Machinery,
    states: [
      "scheduled",
      "performing",
      "transmitted",
      "partial",
      "complete",
      "incomplete",
      "canceled",
      "failed"
    ],
    transitions: %{
      "scheduled" => ["performing", "canceled"],
      "performing" => ["transmitted", "canceled"],
      "transmitted" => ["partial", "complete", "incomplete"],
      "partial" => "complete",
      "incomplete" => ["partial", "complete"],
      "*" => "failed"
    }

  require Logger

  alias Adam.Communication
  alias Adam.Communication.Transmission
  alias Adam.Information

  @doc false
  def before_transition(%Transmission{id: id}, _next_state) do
    Communication.get_transmission!(id)
  end

  @doc false
  def after_transition(transmission, state) do
    :ok = Communication.broadcast_transmission(transmission, state)

    transmission
  end

  @doc false
  def persist(transmission, next_state) do
    {:ok, %{transmission: transmission}} =
      Information.create_transmission_state(transmission, next_state)

    transmission
  end

  @doc false
  def guard_transition(%Transmission{scheduled_at: scheduled_at} = transmission, "performing") do
    if scheduled_at > NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second) do
      scheduled_at = NaiveDateTime.to_string(scheduled_at)
      {:error, "Cannot perform because it is scheduled to #{scheduled_at}."}
    else
      transmission
    end
  end

  def guard_transition(%Transmission{state: state}, next_state) when state == next_state do
    {:error, "The transmission is already #{next_state}."}
  end

  @doc false
  def log_transition(%Transmission{id: id} = transmission, next_state) do
    from = "transmission_id: #{id}"
    to = "to: #{next_state}"

    Logger.info("[#{__MODULE__}] Performing state transition of #{from} #{to}")

    transmission
  end
end
