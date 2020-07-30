defmodule Adam.CommunicationTest do
  use Adam.DataCase

  import Adam.Factory

  alias Adam.Communication

  describe "transmissions" do
    alias Adam.Communication.Transmission

    @valid_attrs %{
      label: "some label",
      scheduled_at: ~N[2010-04-17 14:00:00],
      state: "some state"
    }
    @update_attrs %{
      label: "some updated label",
      scheduled_at: ~N[2011-05-18 15:01:01],
      state: "some updated state"
    }
    @invalid_attrs %{label: nil, scheduled_at: nil, state: nil}

    test "list_transmissions/0 returns all transmissions" do
      transmission = insert(:transmission)
      assert Communication.list_transmissions() == [transmission]
    end

    test "get_transmission!/1 returns the transmission with given id" do
      transmission = insert(:transmission)

      assert Communication.get_transmission!(transmission.id) == transmission
    end

    test "create_transmission/1 with valid data creates a transmission" do
      assert {:ok, %Transmission{} = transmission} =
               Communication.create_transmission(@valid_attrs)

      assert transmission.label == "some label"
      assert transmission.scheduled_at == ~N[2010-04-17 14:00:00]
      assert transmission.state == "scheduled"
    end

    test "create_transmission/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Communication.create_transmission(@invalid_attrs)
    end

    test "update_transmission/2 with valid data updates the transmission" do
      transmission = insert(:transmission)

      assert {:ok, %Transmission{} = transmission} =
               Communication.update_transmission(transmission, @update_attrs)

      assert transmission.label == "some updated label"
      assert transmission.scheduled_at == ~N[2011-05-18 15:01:01]
      assert transmission.state == "some updated state"
    end

    test "update_transmission/2 with invalid data returns error changeset" do
      transmission = insert(:transmission)

      assert {:error, %Ecto.Changeset{}} =
               Communication.update_transmission(transmission, @invalid_attrs)

      assert transmission == Communication.get_transmission!(transmission.id)
    end

    # test "delete_transmission/1 deletes the transmission" do
    #   transmission = insert(:transmission)
    #   assert {:ok, %Transmission{}} = Communication.delete_transmission(transmission)
    #   assert_raise Ecto.NoResultsError, fn -> Communication.get_transmission!(transmission.id) end
    # end

    test "change_transmission/1 returns a transmission changeset" do
      transmission = insert(:transmission)
      assert %Ecto.Changeset{} = Communication.change_transmission(transmission)
    end
  end

  describe "messages" do
    alias Adam.Communication.Message

    @valid_attrs %{
      provider: "some provider",
      receiver: "some receiver",
      sender: "some sender",
      state: "some state",
      type: "some type"
    }
    @update_attrs %{
      provider: "some updated provider",
      receiver: "some updated receiver",
      sender: "some updated sender",
      state: "some updated state",
      type: "some updated type"
    }
    @invalid_attrs %{provider: nil, receiver: nil, sender: nil, state: nil, type: nil}

    def message_fixture(attrs \\ %{}) do
      {:ok, message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Communication.create_message()

      message
    end

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Communication.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Communication.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      assert {:ok, %Message{} = message} = Communication.create_message(@valid_attrs)
      assert message.provider == "some provider"
      assert message.receiver == "some receiver"
      assert message.sender == "some sender"
      assert message.state == "some state"
      assert message.type == "some type"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Communication.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      assert {:ok, %Message{} = message} = Communication.update_message(message, @update_attrs)
      assert message.provider == "some updated provider"
      assert message.receiver == "some updated receiver"
      assert message.sender == "some updated sender"
      assert message.state == "some updated state"
      assert message.type == "some updated type"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Communication.update_message(message, @invalid_attrs)
      assert message == Communication.get_message!(message.id)
    end

    # test "delete_message/1 deletes the message" do
    #   message = message_fixture()
    #   assert {:ok, %Message{}} = Communication.delete_message(message)
    #   assert_raise Ecto.NoResultsError, fn -> Communication.get_message!(message.id) end
    # end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Communication.change_message(message)
    end
  end
end
