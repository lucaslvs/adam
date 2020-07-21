defmodule Adam.Communication.Transmission.Machinery do
  use Machinery,
    states: ["processed", "in_progress", "transmitted", "partial", "complete", "incomplete", "canceled", "failure"],
    transitions: %{
      "processed" =>  ["in_progress", "canceled"],
      "in_progress" => ["transmitted", "canceled"],
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

  def log_transition(%Transmission{id: id, state: state} = transmission, next_state) do
    Logger.info("[#{__MODULE__}] transmission #{id} - Performing state transition from #{state} to #{next_state}")

    transmission
  end
end
