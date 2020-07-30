defmodule Adam.PubSub do
  alias Phoenix.PubSub

  def broadcast(topic, message) when is_binary(topic) and is_tuple(message) do
    PubSub.broadcast(__MODULE__, topic, message)
  end

  def subscribe(topic) when is_binary(topic) do
    PubSub.subscribe(__MODULE__, topic)
  end
end
