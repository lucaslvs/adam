defmodule Adam.Information do
  @moduledoc """
  The Information context.
  """

  import Adam.Factory
  import Ecto.Query, warn: false

  alias Adam.Repo
  alias Adam.Communication
  alias Adam.Communication.{Transmission, Message}
  alias Adam.Information.State
  alias Ecto.Multi

  @doc """
  List all `State` by the given `Transmission`.

  ## Examples
      iex> transmission = Adam.Communication.get_transmission!(1)
      %Transmission{id: 1}

      iex> list_transmission_states(transmission)
      [%State{transmission_id: 1}, ...]

  """
  def list_transmission_states(%Transmission{states: states} = transmission) do
    if Ecto.assoc_loaded?(states) do
      states
    else
      transmission
      |> Ecto.assoc(:states)
      |> Repo.all()
    end
  end

  @doc """
  Creates a new `State` for the given `Transmission`.

  TODO insert examples
  """
  def create_transmission_state(%Transmission{} = transmission, state) when is_binary(state) do
    Multi.new()
    |> Multi.update(:transmission, transmission_changeset(transmission, state))
    |> Multi.insert(:state, &build_transmission_state/1)
    |> Repo.transaction()
  end

  defp transmission_changeset(transmission, next_state) do
    Communication.change_transmission(transmission, %{state: next_state})
  end

  defp build_transmission_state(%{transmission: transmission}) do
    :transmission_state
    |> build(transmission: transmission)
    |> State.transmission_changeset(%{value: transmission.state})
  end

  @doc """
  Check if the given `Transmission` already had the given `state`.

  ## Examples
      iex> transmission = Adam.Communication.get_transmission!(1)
      %Adam.Communication.Transmission{state: "scheduled"}

      iex> transmission_already_had_in?(transmission, "scheduled")
      true

      iex> transmission_already_had_in?(transmission, "performing")
      false
  """
  def transmission_already_had_in?(%Transmission{id: id, states: states}, state)
      when is_binary(state) do
    if Ecto.assoc_loaded?(states) do
      Enum.any?(states, &(&1.transmission_id == id and &1.value == state))
    else
      Map.new()
      |> Map.put("transmission_id", id)
      |> Map.put("value", state)
      |> State.filter()
      |> Repo.exists?()
    end
  end

  @doc """
  Load all `State`s of the given `Transmission` or `Message`.

  ## Examples
      iex> transmission = Adam.Communication.get_transmission!(1)
      %Adam.Communication.Transmission{id: 1}

      iex> load_states(transmission)
      %Adam.Communication.Transmission{
        id: 1,
        states: [%State{transmission_id: 1}, ...]
      }

      iex> message = Adam.Communication.get_message!(1)
      %Adam.Communication.Message{id: 1}

      iex> load_states(message)
      %Adam.Communication.Message{
        id: 1,
        states: [%State{message_id: 1}, ...]
      }
  """
  def load_states(%Transmission{} = transmission), do: Repo.preload(transmission, :states)
  def load_states(%Message{} = message), do: Repo.preload(message, :states)
end
