defmodule Adam.Information do
  @moduledoc """
  The Information context.
  """

  import Ecto.Query, warn: false

  alias Adam.Repo
  alias Adam.Communication
  alias Adam.Communication.Transmission
  alias Adam.Information.TransmissionState
  alias Ecto.Multi

  @doc """
  Load all `TransmissionState` of the given `Transmission`.

  ## Examples
      iex> transmission = Adam.Communication.get_transmission!(1)
      %Transmission{id: 1}

      iex> load_states(transmission)
      %Transmission{
        id: 1,
        states: [%TransmissionState{transmission_id: 1}, ...]
      }

  """
  def load_states(%Transmission{} = transmission) do
    Repo.preload(transmission, :states)
  end

  @doc """
  List all `TransmissionState` by the given `Transmission`.

  ## Examples
      iex> transmission = Adam.Communication.get_transmission!(1)
      %Transmission{id: 1}

      iex> list_transmission_states(transmission)
      [%TransmissionState{transmission_id: 1}, ...]

  """
  def list_transmission_states(%Transmission{} = transmission) do
    transmission
    |> Ecto.assoc(:states)
    |> Repo.all()
  end

  def create_transmission_state(%Transmission{} = transmission, state) do
    transmission_changeset = Communication.change_transmission(transmission, %{state: state})
    transmission_state_association = &build_transmission_state(Map.get(&1, :transmission), state)

    Multi.new()
    |> Multi.update(:transmission, transmission_changeset)
    |> Multi.insert(:state, transmission_state_association)
    |> Repo.transaction()
  end

  @doc """
  Returns a `Ecto.Changeset` for tracking a new `TransmissionState` with the given `Transmission` and `value`.

  ## Examples
      iex> transmission = Adam.Communication.get_transmission!(1)
      %Adam.Communication.Transmission{id: 1}

      iex> build_transmission_state(transmission, "performing")
      %Ecto.Changeset{
        data: %TransmissionState{transmission_id: 1},
        changes: %{value: "performing"}
      }

  """
  def build_transmission_state(%Transmission{} = transmission, state) do
    transmission
    |> Ecto.build_assoc(:states)
    |> TransmissionState.changeset(%{value: state})
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
  def transmission_already_had_in?(%Transmission{id: id}, state) when is_binary(state) do
    TransmissionState
    |> where([state], state.transmission_id == ^id)
    |> where([state], state.value == ^state)
    |> Repo.exists?()
  end
end
