defmodule AdamWeb.V1.TransmissionController do
  use AdamWeb, :controller

  alias Adam.Communication
  alias Adam.Communication.Transmission

  action_fallback AdamWeb.FallbackController

  def index(conn, params) do
    transmissions_page =
      params
      |> Map.put("preload", [:contents, messages: :contents])
      |> Communication.filter_transmissions()

    render(conn, "index.json", page: transmissions_page)
  end

  def create(conn, %{"transmission" => params}) do
    with {:ok, %Transmission{} = transmission} <- Communication.schedule_transmission(params) do
      conn
      |> put_status(:accepted)
      |> put_resp_header("location", Routes.v1_transmission_path(conn, :show, transmission))
      |> render("show.json", transmission: transmission)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %Transmission{} = transmission} <-
           Communication.get_transmission(id, [:contents, messages: :contents]) do
      render(conn, "show.json", transmission: transmission)
    end
  end
end
