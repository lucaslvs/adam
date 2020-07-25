defmodule Adam.Communication do
  @moduledoc """
  The Communication context.
  """

  import Ecto.Query, warn: false

  alias Adam.Repo
  alias Adam.Communication.Transmission

  @doc """
  List all `Transmission`.

  ## Examples

      iex> list_transmissions()
      [%Transmission{}, ...]

  """
  def list_transmissions, do: Repo.all(Transmission)

  @doc """
  Gets a single `Transmission` by the given `id`.

  Raises `Ecto.NoResultsError` if the `Transmission` does not exist.

  ## Examples

      iex> get_transmission!(123)
      %Transmission{id: 123}

      iex> get_transmission!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transmission!(id), do: Repo.get!(Transmission, id)

  @doc """
  Creates a `Transmission` by the given attributes.

  ## Examples

      iex> create_transmission(%{label: "registration_confirmation"})
      {:ok, %Transmission{label: "registration_confirmation"}}

      iex> create_transmission(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transmission(attrs \\ %{}) do
    %Transmission{}
    |> Transmission.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a `Transmission` by the given attributes.

  ## Examples

      iex> update_transmission(transmission, %{label: "new_value"})
      {:ok, %Transmission{label: "new_value"}}

      iex> update_transmission(transmission, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transmission(%Transmission{} = transmission, attrs) do
    transmission
    |> Transmission.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transmission changes.

  ## Examples

      iex> change_transmission(transmission)
      %Ecto.Changeset{data: %Transmission{}}

  """
  def change_transmission(%Transmission{} = transmission, attrs \\ %{}) do
    Transmission.changeset(transmission, attrs)
  end
end
