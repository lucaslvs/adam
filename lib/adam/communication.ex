defmodule Adam.Communication do
  @moduledoc """
  The Communication context.
  """

  alias Adam.Repo
  alias Adam.Communication.{Transmission, Message}

  @doc """
  List all `Transmission`.

  ## Examples

      iex> list_transmissions()
      [%Transmission{}, ...]

  """
  def list_transmissions, do: Repo.all(Transmission)

  @doc """
  Returns a `Scriviner.Page` with a list of `Transmission` filtered by the given attributes.

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
  Returns an `Ecto.Changeset` for tracking transmission changes.

  ## Examples

      iex> change_transmission(transmission)
      %Ecto.Changeset{data: %Transmission{}}

  """
  def change_transmission(%Transmission{} = transmission, attrs \\ %{}) do
    Transmission.changeset(transmission, attrs)
  end

  @doc """
  Returns the list of `Message`.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages, do: Repo.all(Message)

  @doc """
  Gets a single `Message`.

  Raises `Ecto.NoResultsError` if the `Message` does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Gets a single `Message` by the given `id`.

  ## Examples

      iex> get_message(123)
      {:ok, %Message{id: 123}}

      iex> get_message(456)
      {:error, :not_found}

  """
  def get_message(id) do
    {:ok, get_message!(id)}
  rescue
    Ecto.NoResultsError ->
      {:error, :not_found}
  end

  @doc """
  Creates a `Message`.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a `Message`.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `Ecto.Changeset` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end
end
