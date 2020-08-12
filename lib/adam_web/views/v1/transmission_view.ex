defmodule AdamWeb.V1.TransmissionView do
  @moduledoc false

  use AdamWeb, :view

  alias AdamWeb.V1.{ContentView, TransmissionView, MessageView}

  def render("index.json", %{transmissions: transmissions}) do
    %{transmissions: render_many(transmissions, TransmissionView, "transmission.json")}
  end

  def render("index.json", %{page: %Scrivener.Page{} = page}) do
    %{
      transmissions: render_many(page.entries, TransmissionView, "transmission.json"),
      page_number: page.page_number,
      page_size: page.page_size,
      total_transmissions: page.total_entries,
      total_pages: page.total_pages
    }
  end

  def render("show.json", %{transmission: transmission}) do
    %{transmission: render_one(transmission, TransmissionView, "transmission.json")}
  end

  def render("transmission.json", %{transmission: transmission}) do
    %{
      id: transmission.id,
      inserted_at: transmission.inserted_at,
      updated_at: transmission.updated_at,
      label: transmission.label,
      state: transmission.state,
      scheduled_at: transmission.scheduled_at,
      messages: render_many(transmission.messages, MessageView, "message.json"),
      contents: ContentView.render_many_contents(transmission.contents)
    }
  end
end
