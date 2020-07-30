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

  alias Adam.Communication
  alias Adam.Communication.Message
  alias Adam.Information

  @doc false
  def before_transition(%Message{id: id}, _next_state) do
    Communication.get_message!(id)
  end

  @doc false
  def after_transition(%Message{id: id},  _next_state) do
    id
    |> Communication.get_message!()
    |> Information.load_states()
  end

  @doc false
  def persist(message, next_state) do
    {:ok, %{message: message}} =
      Information.create_message_state(message, next_state)

      message
  end

  @doc false
  def log_transition(%Message{id: id} = message, next_state) do
    from = "message_id: #{id}"
    to = "to: #{next_state}"

    Logger.info("[#{__MODULE__}] Performing state transition of #{from} #{to}")

    message
  end
end
