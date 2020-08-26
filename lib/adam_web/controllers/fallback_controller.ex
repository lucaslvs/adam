defmodule AdamWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use AdamWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(AdamWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, message, _}) when is_binary(message) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(AdamWeb.ErrorView)
    |> render("error.json", message: message)
  end

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, errors}) when is_map(errors) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(AdamWeb.ErrorView)
    |> render("error.json", errors: errors)
  end

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, {:validation, errors}}) when is_map(errors) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(AdamWeb.ErrorView)
    |> render("error.json", errors: errors)
  end

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:interrupt, errors}) when is_map(errors) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(AdamWeb.ErrorView)
    |> render("error.json", errors: errors)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(AdamWeb.ErrorView)
    |> render(:"404")
  end
end
