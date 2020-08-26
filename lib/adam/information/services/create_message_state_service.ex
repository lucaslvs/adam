defmodule Adam.Information.CreateMessageStateService do
  use Exop.Operation

  import Adam.Factory

  alias Adam.{Communication, Repo}
  alias Adam.Communication.Message
  alias Adam.Information.State
  alias Ecto.Multi

  @states [
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
  ]

  parameter(:message, from: "message", struct: Message)
  parameter(:state, from: "state", type: :string, in: @states)

  @impl Exop.Operation
  def process(%{message: message, state: state}) do
    Multi.new()
    |> update_message(message, state)
    |> create_message_state()
    |> perform_transaction()
  end

  defp update_message(multi, message, state) do
    Multi.update(multi, :message, message_changeset(message, state))
  end

  defp message_changeset(message, next_state) do
    Communication.change_message(message, Map.new(state: next_state))
  end

  defp create_message_state(multi) do
    Multi.insert(multi, :state, &build_message_state/1)
  end

  defp build_message_state(%{message: %Message{state: state} = message}) do
    :message_state
    |> build(message: message)
    |> State.message_changeset(%{value: state})
  end

  defp perform_transaction(multi) do
    case Repo.transaction(multi) do
      {:ok, %{message: message}} ->
        message

      transaction_result ->
        transaction_result
    end
  end
end
