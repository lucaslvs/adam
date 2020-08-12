defmodule Adam.Communication.Message.Machinery do
  @moduledoc false

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
  alias Adam.Communication.{Transmission, Message}
  alias Adam.Information
  alias Adam.PubSub

  @doc false
  def before_transition(%Message{id: id}, _next_state) do
    Communication.get_message!(id)
  end

  @doc false
  def after_transition(message, state) do
    broadcast_transition(message, state)

    message
  end

  defp broadcast_transition(%Message{id: id} = message, state) when is_binary(state) do
    PubSub.broadcast("message:#{id}", {String.to_atom(state), message})
  end

  @doc false
  def persist(message, next_state) do
    {:ok, %{message: message}} = Information.create_message_state(message, next_state)

    message
  end

  @doc false
  def guard_transition(message, "sending") do
    transmission =
      case message do
        %Message{transmission: %Transmission{} = transmission} ->
          transmission

        message ->
          Communication.load_transmission(message)
      end

    cond do
      Transmission.is_performing?(transmission) ->
        message

      Transmission.is_scheduled?(transmission) ->
        {:error, "Cannot send because transmission_id: #{transmission.id} is still scheduled."}

      Transmission.is_canceled?(transmission) ->
        {:error, "Cannot send because transmission_id: #{transmission.id} is canceled."}

      true ->
        {:error, "Cannot send because transmission_id: #{transmission.id} is not performing."}
    end
  end

  def guard_transition(%Message{state: state}, next_state) when state == next_state do
    {:error, "The message is already #{next_state}."}
  end

  @doc false
  def log_transition(%Message{id: id} = message, next_state) do
    from = "message_id: #{id}"
    to = "to: #{next_state}"

    Logger.info("[#{__MODULE__}] Performing state transition of #{from} #{to}")

    message
  end
end
