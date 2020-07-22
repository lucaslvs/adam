defmodule Adam.Factory do
  use ExMachina.Ecto, repo: Adam.Repo

  alias Adam.Communication.Transmission

  def transmission_factory do
    %Transmission{
      label: "label",
      state: "scheduled",
      scheduled_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
    }
  end
end
