defmodule AdamWeb.V1.MessageView do
  use AdamWeb, :view
  alias AdamWeb.V1.MessageView

  def render("index.json", %{messages: messages}) do
    %{data: render_many(messages, MessageView, "message.json")}
  end

  def render("show.json", %{message: message}) do
    %{data: render_one(message, MessageView, "message.json")}
  end

  def render("message.json", %{message: message}) do
    %{
      id: message.id,
      state: message.state,
      type: message.type,
      provider: message.provider,
      sender: message.sender,
      receiver: message.receiver
    }
  end
end
