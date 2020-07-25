defmodule Adam.Factory do
  use ExMachina.Ecto, repo: Adam.Repo

  alias Adam.Communication.Transmission
  alias Adam.Information.TransmissionState

  @doc false
  def transmission_factory do
    %Transmission{
      label: "label",
      state: "scheduled",
      scheduled_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
    }
  end

  @doc false
  def transmission_state_factory(attrs) do
    case attrs do
      %{transmission: %Transmission{} = transmission} ->
        Ecto.build_assoc(transmission, :states, attrs)

      _ ->
        struct!(TransmissionState, attrs)
    end
  end
end
