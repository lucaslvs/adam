defmodule Adam.Communication.Message.Machinery do
  use Machinery,
    states: [
      "pending",
      "sending",
      "sent",
      "delivered",
      "undelivered",
      "received",
      "unreceived",
      "interacted",
      "canceled",
      "failed"
    ],
    transitions: %{
      "pending" => ["sending", "canceled"],
      "sending" => ["sent", "canceled"],
      "sent" => ["delivered", "undelivered"],
      "delivered" => ["received", "unreceived"],
      "received" => "interacted",
      "*" => "failed"
    }

  require Logger

  alias Adam.Communication.Message

  @doc false
  def log_transition(%Message{id: id} = message, next_state) do
    from = "message_id: #{id}"
    to = "to: #{next_state}"

    Logger.info("[#{__MODULE__}] Performing state transition of #{from} #{to}")

    message
  end
end
