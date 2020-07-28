defmodule Adam.Communication.Message.Machinery do
  use Machinery,
    states: [
      "pending",
      "sending",
      "sent",
      "delivered",
      "canceled",
      "received",
      "failed"
    ],
    transitions: %{
      "*" => "failed"
    }

  require Logger
end
