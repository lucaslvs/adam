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

  def transmission_state_factory(attrs) do
    %{transmission: %Transmission{} = transmission} = attrs
    Ecto.build_assoc(transmission, :states, attrs)
  end
end
