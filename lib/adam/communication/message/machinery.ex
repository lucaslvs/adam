defmodule Adam.Communication.Message.Machinery do
  use Machinery,
    states: [
      "pending",
      "sending",
      "sent",
      "delivered",
      "undelivered",
      "received",
      "unreceived",
      "interacted",
      "canceled",
      "failed"
    ],
    transitions: %{
      "pending" => ["sending", "canceled"],
      "sending" => ["sent", "canceled"],
      "sent" => ["delivered", "undelivered"],
      "delivered" => ["received", "unreceived"],
      "received" => "interacted",
      "*" => "failed"
    }

  require Logger
end
