defmodule AdamWeb.V1.TransmissionView do
  use AdamWeb, :view
  alias AdamWeb.V1.TransmissionView

  def render("index.json", %{transmissions: transmissions}) do
    %{data: render_many(transmissions, TransmissionView, "transmission.json")}
  end

  def render("show.json", %{transmission: transmission}) do
    %{data: render_one(transmission, TransmissionView, "transmission.json")}
  end

  def render("transmission.json", %{transmission: transmission}) do
    %{
      id: transmission.id,
      label: transmission.label,
      state: transmission.state,
      scheduled_at: transmission.scheduled_at
    }
  end
end
