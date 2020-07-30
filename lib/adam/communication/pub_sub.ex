defmodule Adam.Communication.PubSub do
  use Adam, :pub_sub

  alias Adam.Communication.Transmission

  def transmission_sending(%Transmission{} = transmission) do
    broadcast("transmission", {:transmission_sending, transmission})

    {:ok, transmission}
  end
end
