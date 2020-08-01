defmodule Adam.Communication do
  @moduledoc """
  The Communication context.
  """

  alias Adam.Repo
  alias __MODULE__.{Transmission, Message}

  @doc """
  List all `Transmission`s.

  ## Examples

      iex> list_transmissions()
      [%Transmission{}, ...]

  """
  def list_transmissions, do: Repo.all(Transmission)

  @doc """
  Returns a `Scriviner.Page` with a list of `Transmission`s filtered by the given attributes.

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
  Gets a single `Transmission` by the given attributes.

  Raises `Ecto.NoResultsError` if the `Transmission` with the given attributes does not exist.

  ## Examples

      iex> get_transmission_by!(label: "registration_confirmation")
      %Transmission{label: "registration_confirmation"}

      iex> get_transmission_by!(label: "invalid_label")
      ** (Ecto.NoResultsError)

  """
  def get_transmission_by!(attrs) when is_map(attrs) do
    Repo.get_by!(Transmission, attrs)
  end

  @doc """
  Gets a single `Transmission` by the given attributes.

  ## Examples

      iex> get_transmission_by(label: "registration_confirmation")
      {:ok, %Transmission{label: "registration_confirmation"}}

      iex> get_transmission_by!(label: "invalid_label")
      {:error, :not_found}

  """
  def get_transmission_by(attrs) when is_map(attrs) do
    {:ok, get_transmission_by!(attrs)}
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
    Transmission
    |> struct!()
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
  Load `Transmission` of the given `Message`.

  ## Examples
      iex> message = get_message!(1)
      %Message{id: 1, transmission_id: 1}

      iex> load_transmission(message)
      %Message{
        id: 1,
        transmission_id: 1,
        transmission: Transmission{id: 1}
      }
  """
  def load_transmission(%Message{} = message), do: Repo.preload(message, :transmission)

  @doc """
  Returns the list of `Message`.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages, do: Repo.all(Message)

  @doc """
  Returns a `Scriviner.Page` with a list of `Message`s filtered by the given attributes.

  TODO insert examples

  ## Examples

      iex> filter_messages(attrs)
      [%Message{}, ...]
  """
  def filter_messages(attrs \\ %{}) do
    attrs
    |> Message.filter()
    |> Repo.paginate(attrs)
  end

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
  Gets a single `Message` by the given attributes.

  Raises `Ecto.NoResultsError` if the `Message` with the given attributes does not exist.

  ## Examples

      iex> get_message_by!(type: "email", provider: "sendgrid")
      %Message{type: "email", provider: "sendgrid"}

      iex> get_message_by!(type: "invalid_type", provider: "invalid_provider")
      ** (Ecto.NoResultsError)

  """
  def get_message_by!(attrs) when is_map(attrs) do
    Repo.get_by!(Message, attrs)
  end

  @doc """
  Gets a single `Message` by the given attributes.

  ## Examples

      iex> get_message_by(type: "email", provider: "sendgrid")
      {:ok, %Message{type: "email", provider: "sendgrid"}}

      iex> get_message_by(type: "invalid_type", provider: "invalid_provider")
      {:error, :not_found}

  """
  def get_message_by(attrs) when is_map(attrs) do
    {:ok, get_message_by!(attrs)}
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
    Message
    |> struct!()
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

  @doc """
  Load `Message` of the given `Transmission`.

  ## Examples
      iex> transmission = get_transmission!(1)
      %Transmission{id: 1}

      iex> load_messages(transmisson)
      %Transmisson{
        id: 1,
        messages: [Message{transmission_id: 1}]
      }
  """
  def load_messages(%Transmission{} = transmission), do: Repo.preload(transmission, :messages)
end
