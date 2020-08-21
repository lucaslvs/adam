defmodule Adam.Communication.TransmissionTest do
  use Adam.DataCase

  import Adam.Factory

  alias Adam.Communication.Transmission

  describe "changeset/2" do
    @valid_attrs %{label: "some label", scheduled_at: ~N[2010-04-17 14:00:00]}
    @invalid_attrs %{label: nil, scheduled_at: nil}

    setup do
      {:ok, transmission: struct!(Transmission)}
    end

    test "should returns a valid transmission", %{transmission: transmission} do
      received = Transmission.changeset(transmission, @valid_attrs)

      assert %Ecto.Changeset{valid?: true, changes: changes} = received
      assert @valid_attrs = changes
    end

    test "should returns a changeset with errors", %{transmission: transmission} do
      received = Transmission.changeset(transmission, @invalid_attrs)

      assert %Ecto.Changeset{valid?: false} = received
    end
  end

  # describe "schedule_changeset/2" do
  #   @valid_attrs %{label: "some label", scheduled_at: ~N[2010-04-17 14:00:00]}
  #   @invalid_attrs %{label: nil, scheduled_at: nil}

  #   setup do
  #     {:ok, transmission: struct!(Transmission)}
  #   end

  #   test "should returns a valid transmission", %{transmission: transmission} do
  #     received = Transmission.schedule_changeset(transmission, @valid_attrs)

  #     assert %Ecto.Changeset{valid?: true, changes: changes} = received
  #     assert @valid_attrs = changes
  #   end

  #   test "should returns a changeset with errors", %{transmission: transmission} do
  #     received = Transmission.schedule_changeset(transmission, @invalid_attrs)

  #     assert %Ecto.Changeset{valid?: false} = received
  #   end
  # end

  describe "to_perform/1" do
    setup do
      transmissions = [
        insert(:transmission, state: "performing"),
        insert(:transmission, state: "transmitted"),
        insert(:transmission, state: "partial"),
        insert(:transmission, state: "complete"),
        insert(:transmission, state: "incomplete"),
        insert(:transmission, state: "canceled"),
        insert(:transmission, state: "failed")
      ]

      scheduled_at =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.add(10)
        |> NaiveDateTime.truncate(:second)

      scheduled = insert(:transmission, scheduled_at: scheduled_at)

      {:ok,
       transmission: insert(:transmission), scheduled: scheduled, transmissions: transmissions}
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
         %{scheduled: transmission} do
      assert {:error, reason, transmission} = Transmission.to_perform(transmission)

      scheduled_at = NaiveDateTime.to_string(transmission.scheduled_at)

      assert reason == "Cannot perform because it is scheduled to #{scheduled_at}."
    end

    test "should not transition to 'performing' when receiving a unscheduled transmission", %{
      transmissions: transmissions
    } do
      Enum.each(transmissions, fn transmission ->
        assert {:error, "Transition to this state isn't declared.", transmission} =
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
        insert(:transmission, state: "canceled"),
        insert(:transmission, state: "failed")
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

    test "should not transition to 'canceled' when receiving a transmission that is not 'scheduled' or 'performing'",
         %{
           transmissions: transmissions
         } do
      Enum.each(transmissions, fn transmission ->
        assert {:error, "Transition to this state isn't declared.", transmission} =
                 Transmission.to_cancel(transmission)
      end)
    end
  end

  describe "to_transmit/1" do
    setup do
      transmissions = [
        insert(:transmission, state: "scheduled"),
        insert(:transmission, state: "transmitted"),
        insert(:transmission, state: "partial"),
        insert(:transmission, state: "complete"),
        insert(:transmission, state: "incomplete"),
        insert(:transmission, state: "canceled"),
        insert(:transmission, state: "failed")
      ]

      performing = insert(:transmission, state: "performing")

      {:ok, performing: performing, transmissions: transmissions}
    end

    test "should transition to 'transmitted' when receiving a 'performing' transmission", %{
      performing: transmission
    } do
      assert {:ok, %Transmission{} = received} = Transmission.to_transmit(transmission)
      assert received.id == transmission.id
      assert received.scheduled_at == transmission.scheduled_at
      assert received.state == "transmitted"
    end

    test "should not transition to 'transmitted' when receiving a transmission that is not 'performing'",
         %{
           transmissions: transmissions
         } do
      Enum.each(transmissions, fn transmission ->
        assert {:error, "Transition to this state isn't declared.", transmission} =
                 Transmission.to_transmit(transmission)
      end)
    end
  end

  describe "to_partial/1" do
    setup do
      transmissions = [
        insert(:transmission, state: "scheduled"),
        insert(:transmission, state: "performing"),
        insert(:transmission, state: "partial"),
        insert(:transmission, state: "complete"),
        insert(:transmission, state: "canceled"),
        insert(:transmission, state: "failed")
      ]

      transmitted = insert(:transmission, state: "transmitted")
      incomplete = insert(:transmission, state: "incomplete")

      {:ok, transmitted: transmitted, incomplete: incomplete, transmissions: transmissions}
    end

    test "should transition to 'partial' when receiving a 'transmitted' transmission", %{
      transmitted: transmission
    } do
      assert {:ok, %Transmission{} = received} = Transmission.to_partial(transmission)
      assert received.id == transmission.id
      assert received.scheduled_at == transmission.scheduled_at
      assert received.state == "partial"
    end

    test "should transition to 'partial' when receiving a 'incomplete' transmission", %{
      incomplete: transmission
    } do
      assert {:ok, %Transmission{} = received} = Transmission.to_partial(transmission)
      assert received.id == transmission.id
      assert received.scheduled_at == transmission.scheduled_at
      assert received.state == "partial"
    end

    test "should not transition to 'partial' when receiving a transmission that is not 'transmitted' or 'incomplete'",
         %{
           transmissions: transmissions
         } do
      Enum.each(transmissions, fn transmission ->
        assert {:error, "Transition to this state isn't declared.", transmission} =
                 Transmission.to_partial(transmission)
      end)
    end
  end

  describe "to_complete/1" do
    setup do
      transmissions = [
        insert(:transmission, state: "scheduled"),
        insert(:transmission, state: "performing"),
        insert(:transmission, state: "complete"),
        insert(:transmission, state: "canceled"),
        insert(:transmission, state: "failed")
      ]

      transmitted = insert(:transmission, state: "transmitted")
      partial = insert(:transmission, state: "partial")
      incomplete = insert(:transmission, state: "incomplete")

      {:ok,
       transmitted: transmitted,
       partial: partial,
       incomplete: incomplete,
       transmissions: transmissions}
    end

    test "should transition to 'complete' when receiving a 'transmitted' transmission", %{
      transmitted: transmission
    } do
      assert {:ok, %Transmission{} = received} = Transmission.to_complete(transmission)
      assert received.id == transmission.id
      assert received.scheduled_at == transmission.scheduled_at
      assert received.state == "complete"
    end

    test "should transition to 'complete' when receiving a 'partial' transmission", %{
      partial: transmission
    } do
      assert {:ok, %Transmission{} = received} = Transmission.to_complete(transmission)
      assert received.id == transmission.id
      assert received.scheduled_at == transmission.scheduled_at
      assert received.state == "complete"
    end

    test "should transition to 'complete' when receiving a 'incomplete' transmission", %{
      incomplete: transmission
    } do
      assert {:ok, %Transmission{} = received} = Transmission.to_complete(transmission)
      assert received.id == transmission.id
      assert received.scheduled_at == transmission.scheduled_at
      assert received.state == "complete"
    end

    test "should not transition to 'complete' when receiving a transmission that is not 'transmitted', 'partial' or 'incomplete'",
         %{
           transmissions: transmissions
         } do
      Enum.each(transmissions, fn transmission ->
        assert {:error, "Transition to this state isn't declared.", transmission} =
                 Transmission.to_complete(transmission)
      end)
    end
  end

  describe "to_incomplete/1" do
    setup do
      transmissions = [
        insert(:transmission, state: "scheduled"),
        insert(:transmission, state: "performing"),
        insert(:transmission, state: "partial"),
        insert(:transmission, state: "complete"),
        insert(:transmission, state: "incomplete"),
        insert(:transmission, state: "canceled"),
        insert(:transmission, state: "failed")
      ]

      transmitted = insert(:transmission, state: "transmitted")

      {:ok, transmitted: transmitted, transmissions: transmissions}
    end

    test "should transition to 'incomplete' when receiving a 'transmitted' transmission", %{
      transmitted: transmission
    } do
      assert {:ok, %Transmission{} = received} = Transmission.to_incomplete(transmission)
      assert received.id == transmission.id
      assert received.scheduled_at == transmission.scheduled_at
      assert received.state == "incomplete"
    end

    test "should not transition to 'incomplete' when receiving a transmission that is not 'transmitted'",
         %{
           transmissions: transmissions
         } do
      Enum.each(transmissions, fn transmission ->
        assert {:error, "Transition to this state isn't declared.", transmission} =
                 Transmission.to_incomplete(transmission)
      end)
    end
  end

  describe "to_failure/1" do
    setup do
      transmissions = [
        insert(:transmission, state: "scheduled"),
        insert(:transmission, state: "performing"),
        insert(:transmission, state: "transmitted"),
        insert(:transmission, state: "partial"),
        insert(:transmission, state: "complete"),
        insert(:transmission, state: "incomplete"),
        insert(:transmission, state: "canceled")
      ]

      failure = insert(:transmission, state: "failed")

      {:ok, failure: failure, transmissions: transmissions}
    end

    test "should transition to 'failed' when receiving a transmission that is not `failure`", %{
      transmissions: transmissions
    } do
      Enum.each(transmissions, fn transmission ->
        assert {:ok, %Transmission{} = received} = Transmission.to_failure(transmission)
        assert received.id == transmission.id
        assert received.scheduled_at == transmission.scheduled_at
        assert received.state == "failed"
      end)
    end

    test "should not transition to 'failed' when receiving a `failure` transmission", %{
      failure: transmission
    } do
      assert {:error, "Transition to this state isn't declared.", transmission} =
               Transmission.to_incomplete(transmission)
    end
  end

  describe "is_scheduled?/1" do
    setup do
      transmissions = [
        insert(:transmission, state: "scheduled"),
        insert(:transmission, state: "performing"),
        insert(:transmission, state: "transmitted"),
        insert(:transmission, state: "partial"),
        insert(:transmission, state: "complete"),
        insert(:transmission, state: "incomplete"),
        insert(:transmission, state: "canceled"),
        insert(:transmission, state: "failed")
      ]

      {:ok, transmissions: transmissions}
    end

    test "should returns true when receive a transmission with 'scheduled' state", %{
      transmissions: [transmission | _]
    } do
      assert Transmission.is_scheduled?(transmission)
    end

    test "should returns false when receive a transmission without 'scheduled' state", %{
      transmissions: [_ | transmissions]
    } do
      Enum.each(transmissions, fn transmission ->
        refute Transmission.is_scheduled?(transmission)
      end)
    end
  end

  describe "is_performing?/1" do
    setup do
      transmissions = [
        insert(:transmission, state: "performing"),
        insert(:transmission, state: "scheduled"),
        insert(:transmission, state: "transmitted"),
        insert(:transmission, state: "partial"),
        insert(:transmission, state: "complete"),
        insert(:transmission, state: "incomplete"),
        insert(:transmission, state: "canceled"),
        insert(:transmission, state: "failed")
      ]

      {:ok, transmissions: transmissions}
    end

    test "should returns true when receive a transmission with 'performing' state", %{
      transmissions: [transmission | _]
    } do
      assert Transmission.is_performing?(transmission)
    end

    test "should returns false when receive a transmission without 'performing' state", %{
      transmissions: [_ | transmissions]
    } do
      Enum.each(transmissions, fn transmission ->
        refute Transmission.is_performing?(transmission)
      end)
    end
  end

  describe "is_canceled?/1" do
    setup do
      transmissions = [
        insert(:transmission, state: "canceled"),
        insert(:transmission, state: "scheduled"),
        insert(:transmission, state: "performing"),
        insert(:transmission, state: "transmitted"),
        insert(:transmission, state: "partial"),
        insert(:transmission, state: "complete"),
        insert(:transmission, state: "incomplete"),
        insert(:transmission, state: "failed")
      ]

      {:ok, transmissions: transmissions}
    end

    test "should returns true when receive a transmission with 'canceled' state", %{
      transmissions: [transmission | _]
    } do
      assert Transmission.is_canceled?(transmission)
    end

    test "should returns false when receive a transmission without 'canceled' state", %{
      transmissions: [_ | transmissions]
    } do
      Enum.each(transmissions, fn transmission ->
        refute Transmission.is_canceled?(transmission)
      end)
    end
  end

  describe "is_transmitted?/1" do
    setup do
      transmissions = [
        insert(:transmission, state: "transmitted"),
        insert(:transmission, state: "scheduled"),
        insert(:transmission, state: "performing"),
        insert(:transmission, state: "partial"),
        insert(:transmission, state: "complete"),
        insert(:transmission, state: "incomplete"),
        insert(:transmission, state: "canceled"),
        insert(:transmission, state: "failed")
      ]

      {:ok, transmissions: transmissions}
    end

    test "should returns true when receive a transmission with 'transmitted' state", %{
      transmissions: [transmission | _]
    } do
      assert Transmission.is_transmitted?(transmission)
    end

    test "should returns false when receive a transmission without 'transmitted' state", %{
      transmissions: [_ | transmissions]
    } do
      Enum.each(transmissions, fn transmission ->
        refute Transmission.is_transmitted?(transmission)
      end)
    end
  end

  describe "is_partial?/1" do
    setup do
      transmissions = [
        insert(:transmission, state: "partial"),
        insert(:transmission, state: "transmitted"),
        insert(:transmission, state: "scheduled"),
        insert(:transmission, state: "performing"),
        insert(:transmission, state: "complete"),
        insert(:transmission, state: "incomplete"),
        insert(:transmission, state: "canceled"),
        insert(:transmission, state: "failed")
      ]

      {:ok, transmissions: transmissions}
    end

    test "should returns true when receive a transmission with 'partial' state", %{
      transmissions: [transmission | _]
    } do
      assert Transmission.is_partial?(transmission)
    end

    test "should returns false when receive a transmission without 'partial' state", %{
      transmissions: [_ | transmissions]
    } do
      Enum.each(transmissions, fn transmission ->
        refute Transmission.is_partial?(transmission)
      end)
    end
  end

  describe "is_complete?/1" do
    setup do
      transmissions = [
        insert(:transmission, state: "complete"),
        insert(:transmission, state: "partial"),
        insert(:transmission, state: "transmitted"),
        insert(:transmission, state: "scheduled"),
        insert(:transmission, state: "performing"),
        insert(:transmission, state: "incomplete"),
        insert(:transmission, state: "canceled"),
        insert(:transmission, state: "failed")
      ]

      {:ok, transmissions: transmissions}
    end

    test "should returns true when receive a transmission with 'complete' state", %{
      transmissions: [transmission | _]
    } do
      assert Transmission.is_complete?(transmission)
    end

    test "should returns false when receive a transmission without 'complete' state", %{
      transmissions: [_ | transmissions]
    } do
      Enum.each(transmissions, fn transmission ->
        refute Transmission.is_complete?(transmission)
      end)
    end
  end

  describe "is_incomplete?/1" do
    setup do
      transmissions = [
        insert(:transmission, state: "incomplete"),
        insert(:transmission, state: "complete"),
        insert(:transmission, state: "partial"),
        insert(:transmission, state: "transmitted"),
        insert(:transmission, state: "scheduled"),
        insert(:transmission, state: "performing"),
        insert(:transmission, state: "canceled"),
        insert(:transmission, state: "failed")
      ]

      {:ok, transmissions: transmissions}
    end

    test "should returns true when receive a transmission with 'incomplete' state", %{
      transmissions: [transmission | _]
    } do
      assert Transmission.is_incomplete?(transmission)
    end

    test "should returns false when receive a transmission without 'incomplete' state", %{
      transmissions: [_ | transmissions]
    } do
      Enum.each(transmissions, fn transmission ->
        refute Transmission.is_incomplete?(transmission)
      end)
    end
  end

  describe "is_failed?/1" do
    setup do
      transmissions = [
        insert(:transmission, state: "failed"),
        insert(:transmission, state: "incomplete"),
        insert(:transmission, state: "complete"),
        insert(:transmission, state: "partial"),
        insert(:transmission, state: "transmitted"),
        insert(:transmission, state: "scheduled"),
        insert(:transmission, state: "performing"),
        insert(:transmission, state: "canceled")
      ]

      {:ok, transmissions: transmissions}
    end

    test "should returns true when receive a transmission with 'failed' state", %{
      transmissions: [transmission | _]
    } do
      assert Transmission.is_failed?(transmission)
    end

    test "should returns false when receive a transmission without 'failed' state", %{
      transmissions: [_ | transmissions]
    } do
      Enum.each(transmissions, fn transmission ->
        refute Transmission.is_failed?(transmission)
      end)
    end
  end
end
