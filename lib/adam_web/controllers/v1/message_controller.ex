defmodule AdamWeb.V1.MessageController do
  use AdamWeb, :controller

  alias Adam.Communication
  alias Adam.Communication.Message

  action_fallback AdamWeb.FallbackController

  def index(conn, params) do
    messages_page =
      params
      |> Map.put("preload", [:contents])
      |> Communication.filter_messages()

    render(conn, "index.json", page: messages_page)
  end

  def show(conn, params) do
    params = format_params(params)

    with {:ok, %Message{} = message} <- Communication.get_message_by(params, [:contents]) do
      render(conn, "show.json", message: message)
    end
  end

  # def update(conn, %{"message" => message_params} = params) do
  #   params =
  #     params
  #     |> Map.take(["id", "transmission_id"])
  #     |> format_params()

  #   with {:ok, %Message{} = message} <- Communication.get_message_by(params, [:contents]),
  #        {:ok, %Message{} = message} <- Communication.update_message(message, message_params) do
  #     render(conn, "show.json", message: message)
  #   end
  # end

  defp format_params(params) do
    params
    |> Enum.map(fn {key, value} -> Map.new("#{key}": value) end)
    |> Enum.reduce(Map.new(), &Map.merge(&2, &1))
  end
end
