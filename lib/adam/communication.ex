defmodule Adam.Communication do
  @moduledoc """
  The Communication context.
  """

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
  Returns a `Scriviner.Page` with the given attributes.

  TODO insert examples

  ## Examples

      iex> filter_transmissions(attrs)
      [%Transmission{}, ...]
  """
  def filter_transmissions(attrs \\ %{}) do
    attrs
    |> Transmission.filter()
    |> Repo.paginate(attrs)
  end

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
  Gets a single `Transmission` by the given `id`.

  ## Examples

      iex> get_transmission(123)
      {:ok, %Transmission{id: 123}}

      iex> get_transmission(456)
      {:error, :not_found}

  """
  def get_transmission(id) do
    {:ok, get_transmission!(id)}
  rescue
    Ecto.NoResultsError ->
      {:error, :not_found}
  end

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
    |> change_transmission(attrs)
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
