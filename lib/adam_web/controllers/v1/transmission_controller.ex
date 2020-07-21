defmodule AdamWeb.V1.TransmissionController do
  use AdamWeb, :controller

  alias Adam.Communication
  alias Adam.Communication.Transmission

  action_fallback AdamWeb.FallbackController

  def index(conn, _params) do
    transmissions = Communication.list_transmissions()
    render(conn, "index.json", transmissions: transmissions)
  end

  def create(conn, %{"transmission" => transmission_params}) do
    with {:ok, %Transmission{} = transmission} <- Communication.create_transmission(transmission_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.v1_transmission_path(conn, :show, transmission))
      |> render("show.json", transmission: transmission)
    end
  end

  def show(conn, %{"id" => id}) do
    transmission = Communication.get_transmission!(id)
    render(conn, "show.json", transmission: transmission)
  end

  def update(conn, %{"id" => id, "transmission" => transmission_params}) do
    transmission = Communication.get_transmission!(id)

    with {:ok, %Transmission{} = transmission} <- Communication.update_transmission(transmission, transmission_params) do
      render(conn, "show.json", transmission: transmission)
    end
  end

  def delete(conn, %{"id" => id}) do
    transmission = Communication.get_transmission!(id)

    with {:ok, %Transmission{}} <- Communication.delete_transmission(transmission) do
      send_resp(conn, :no_content, "")
    end
  end
end
