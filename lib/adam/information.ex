defmodule Adam.Information do
  @moduledoc """
  The Information context.
  """

  import Ecto.Query, warn: false

  alias Adam.Repo
  alias Adam.Information.TransmissionState

  @doc """
  Returns the list of transmission_states.

  ## Examples

      iex> list_transmission_states()
      [%TransmissionState{}, ...]

  """
  def list_transmission_states do
    Repo.all(TransmissionState)
  end

  @doc """
  Gets a single transmission_state.

  Raises `Ecto.NoResultsError` if the Transmission state does not exist.

  ## Examples

      iex> get_transmission_state!(123)
      %TransmissionState{}

      iex> get_transmission_state!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transmission_state!(id), do: Repo.get!(TransmissionState, id)

  @doc """
  Creates a transmission_state.

  ## Examples

      iex> create_transmission_state(%{field: value})
      {:ok, %TransmissionState{}}

      iex> create_transmission_state(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transmission_state(attrs \\ %{}) do
    %TransmissionState{}
    |> TransmissionState.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transmission_state.

  ## Examples

      iex> update_transmission_state(transmission_state, %{field: new_value})
      {:ok, %TransmissionState{}}

      iex> update_transmission_state(transmission_state, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transmission_state(%TransmissionState{} = transmission_state, attrs) do
    transmission_state
    |> TransmissionState.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transmission_state.

  ## Examples

      iex> delete_transmission_state(transmission_state)
      {:ok, %TransmissionState{}}

      iex> delete_transmission_state(transmission_state)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transmission_state(%TransmissionState{} = transmission_state) do
    Repo.delete(transmission_state)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transmission_state changes.

  ## Examples

      iex> change_transmission_state(transmission_state)
      %Ecto.Changeset{data: %TransmissionState{}}

  """
  def change_transmission_state(%TransmissionState{} = transmission_state, attrs \\ %{}) do
    TransmissionState.changeset(transmission_state, attrs)
  end
end
