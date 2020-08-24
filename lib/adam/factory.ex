defmodule Adam.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Adam.Repo

  alias Adam.Communication.{Content, Transmission, Message}
  alias Adam.Information.State

  @doc false
  def transmission_factory do
    %Transmission{
      label: "label",
      state: "scheduled",
      scheduled_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
    }
  end

  def message_factory do
    %Message{
      contents: [%{name: "subject", value: "some subject"}],
      type: "email",
      provider: "sendgrid",
      sender: "sender@email.com",
      receiver: "receiver@email.com"
    }
  end

  def state_factory(attrs), do: struct!(State, attrs)

  @doc false
  def transmission_state_factory(attrs) do
    case attrs do
      %{transmission: %Transmission{} = transmission} ->
        Ecto.build_assoc(transmission, :states, attrs)

      %{transmission: _} ->
        raise ":transmission should be a %Transmission{} struct"

      _ ->
        raise ":transmission key is required"
    end
  end

  @doc false
  def message_state_factory(attrs) do
    case attrs do
      %{message: %Message{} = message} ->
        Ecto.build_assoc(message, :states, attrs)

      %{message: _} ->
        raise ":message should be a %Message{} struct"

      _ ->
        raise ":message key is required"
    end
  end

  @doc false
  def content_factory(attrs), do: struct!(Content, attrs)

  @doc false
  def transmission_content_factory(attrs) do
    case attrs do
      %{transmission: %Transmission{} = transmission} ->
        Ecto.build_assoc(transmission, :contents, attrs)

      %{transmission: _} ->
        raise ":transmission should be a %Transmission{} struct"

      _ ->
        raise ":transmission key is required"
    end
  end

  @doc false
  def message_content_factory(attrs) do
    case attrs do
      %{message: %Message{} = message} ->
        Ecto.build_assoc(message, :contents, attrs)

      %{message: _} ->
        raise ":message should be a %Message{} struct"

      _ ->
        raise ":message key is required"
    end
  end
end
