defmodule AdamWeb.V1.MessageView do
  @moduledoc false

  use AdamWeb, :view

  alias AdamWeb.V1.{ContentView, MessageView}

  def render("index.json", %{messages: messages}) do
    %{messages: render_many(messages, MessageView, "message.json")}
  end

  def render("index.json", %{page: %Scrivener.Page{} = page}) do
    %{
      messages: render_many(page.entries, MessageView, "message.json"),
      page_number: page.page_number,
      page_size: page.page_size,
      total_messages: page.total_entries,
      total_pages: page.total_pages
    }
  end

  def render("show.json", %{message: message}) do
    %{message: render_one(message, MessageView, "message.json")}
  end

  def render("message.json", %{message: message}) do
    %{
      id: message.id,
      inserted_at: message.inserted_at,
      updated_at: message.updated_at,
      transmission_id: message.transmission_id,
      state: message.state,
      type: message.type,
      provider: message.provider,
      sender: message.sender,
      receiver: message.receiver,
      contents: ContentView.render_many_contents(message.contents)
    }
  end
end
