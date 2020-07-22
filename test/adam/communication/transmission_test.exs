defmodule Adam.Communication.TransmissionTest do
  use Adam.DataCase

  import Adam.Factory

  alias Adam.Communication.Transmission

  describe "changeset/2" do
    @valid_attrs %{label: "some label", scheduled_at: ~N[2010-04-17 14:00:00]}
    @invalid_attrs %{label: nil, scheduled_at: nil}

    test "should returns a valid transmission" do
      received = Transmission.changeset(struct!(Transmission), @valid_attrs)

      assert %Ecto.Changeset{valid?: true, changes: changes} = received
      assert %{label: "some label", scheduled_at: ~N[2010-04-17 14:00:00]} = changes
    end

    test "should returns a changeset with errors" do
      received = Transmission.changeset(struct!(Transmission), @invalid_attrs)

      assert %Ecto.Changeset{valid?: false} = received
    end
  end

  describe "to_perform/1" do
    setup do
      unscheduled = [
        insert(:transmission, state: "performing"),
        insert(:transmission, state: "transmitted"),
        insert(:transmission, state: "partial"),
        insert(:transmission, state: "complete"),
        insert(:transmission, state: "incomplete"),
        insert(:transmission, state: "canceled"),
        insert(:transmission, state: "failure")
      ]

      scheduled_at =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.add(10)
        |> NaiveDateTime.truncate(:second)

      scheduled = insert(:transmission, scheduled_at: scheduled_at)

      {:ok, transmission: insert(:transmission), scheduled: scheduled, unscheduled: unscheduled}
    end

    test "should transition to 'performing' when receiving a 'scheduled' transmission", %{
      transmission: transmission
    } do
      assert {:ok, %Transmission{} = received} = Transmission.to_perform(transmission)
      assert received.id == transmission.id
      assert received.scheduled_at == transmission.scheduled_at
      assert received.state == "performing"
    end

    test "should not transition to 'performing' when receiving a 'scheduled' transmission when the scheduling time has not arrived",
         %{scheduled: scheduled} do
      assert {:error, reason} = Transmission.to_perform(scheduled)

      scheduled_at = NaiveDateTime.to_string(scheduled.scheduled_at)

      assert reason == "Cannot perform because it is scheduled to #{scheduled_at}"
    end

    test "should not transition to 'performing' when receiving a unscheduled transmission", %{
      unscheduled: unscheduled
    } do
      Enum.each(unscheduled, fn transmission ->
        assert {:error, "Transition to this state isn't declared."} =
                 Transmission.to_perform(transmission)
      end)
    end
  end

  describe "to_cancel/1" do
    setup do
      transmissions = [
        insert(:transmission, state: "transmitted"),
        insert(:transmission, state: "partial"),
        insert(:transmission, state: "complete"),
        insert(:transmission, state: "incomplete"),
        insert(:transmission, state: "failure")
      ]

      scheduled = insert(:transmission)
      performing = insert(:transmission, state: "performing")

      {:ok, performing: performing, scheduled: scheduled, transmissions: transmissions}
    end

    test "should transition to 'canceled' when receiving a 'performing' transmission", %{
      performing: transmission
    } do
      assert {:ok, %Transmission{} = received} = Transmission.to_cancel(transmission)
      assert received.id == transmission.id
      assert received.scheduled_at == transmission.scheduled_at
      assert received.state == "canceled"
    end

    test "should transition to 'canceled' when receiving a 'scheduled' transmission", %{
      scheduled: transmission
    } do
      assert {:ok, %Transmission{} = received} = Transmission.to_cancel(transmission)
      assert received.id == transmission.id
      assert received.scheduled_at == transmission.scheduled_at
      assert received.state == "canceled"
    end

    test "should not transition to 'canceled' when receiving a transmission that is not `scheduled` or `performing`", %{
      transmissions: transmissions
    } do
      Enum.each(transmissions, fn transmission ->
        assert {:error, "Transition to this state isn't declared."} =
                 Transmission.to_perform(transmission)
      end)
    end
  end
end
