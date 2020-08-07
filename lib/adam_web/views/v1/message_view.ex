defmodule AdamWeb.V1.MessageView do
  use AdamWeb, :view

  alias AdamWeb.V1.{ContentView, MessageView}

  def render("index.json", %{messages: messages}) do
    %{messages: render_many(messages, MessageView, "message.json")}
  end

  def render("show.json", %{message: message}) do
    %{message: render_one(message, MessageView, "message.json")}
  end

  def render("message.json", %{message: message}) do
    %{
      id: message.id,
      inserted_at: message.inserted_at,
      updated_at: message.updated_at,
      state: message.state,
      type: message.type,
      provider: message.provider,
      sender: message.sender,
      receiver: message.receiver,
      contents: ContentView.render_many_contents(message.contents)
    }
  end
end
