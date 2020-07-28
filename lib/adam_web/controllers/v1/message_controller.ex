defmodule AdamWeb.V1.MessageController do
  use AdamWeb, :controller

  alias Adam.Communication
  alias Adam.Communication.Message

  action_fallback AdamWeb.FallbackController

  def index(conn, _params) do
    messages = Communication.list_messages()
    render(conn, "index.json", messages: messages)
  end

  def create(conn, %{"message" => message_params}) do
    with {:ok, %Message{} = message} <- Communication.create_message(message_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.v1_message_path(conn, :show, message))
      |> render("show.json", message: message)
    end
  end

  def show(conn, %{"id" => id}) do
    message = Communication.get_message!(id)
    render(conn, "show.json", message: message)
  end

  def update(conn, %{"id" => id, "message" => message_params}) do
    message = Communication.get_message!(id)

    with {:ok, %Message{} = message} <- Communication.update_message(message, message_params) do
      render(conn, "show.json", message: message)
    end
  end

  def delete(conn, %{"id" => id}) do
    message = Communication.get_message!(id)

    with {:ok, %Message{}} <- Communication.delete_message(message) do
      send_resp(conn, :no_content, "")
    end
  end
end
