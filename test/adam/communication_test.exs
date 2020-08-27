defmodule Adam.CommunicationTest do
  use Adam.DataCase

  import Adam.Factory

  alias Adam.Communication

  describe "transmissions" do
    alias Adam.Communication.Transmission

    @valid_attrs %{
      label: "label",
      scheduled_at:
        NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second) |> NaiveDateTime.to_string(),
      contents: %{some: "content"},
      messages: [
        %{
          contents: %{subject: "some subject"},
          type: "email",
          provider: "sendgrid",
          sender: "sender@email.com",
          receiver: "receiver@email.com"
        }
      ]
    }
    @update_attrs %{
      label: "updated_label",
      scheduled_at:
        NaiveDateTime.utc_now()
        |> NaiveDateTime.truncate(:second)
        |> NaiveDateTime.add(1)
        |> NaiveDateTime.to_string()
    }
    @invalid_attrs %{
      label: nil,
      scheduled_at: "2010-04-17 14:00:00",
      messages: []
    }

    test "get_transmission!/1 returns the transmission with given id" do
      transmission = insert(:transmission)

      assert Communication.get_transmission!(transmission.id) == transmission
    end

    test "create_transmission/1 with valid data creates a transmission" do
      assert {:ok, %Transmission{} = transmission} =
               Communication.schedule_transmission(@valid_attrs)

      assert transmission.label == "label"

      assert transmission.scheduled_at ==
               @valid_attrs |> Map.get(:scheduled_at) |> NaiveDateTime.from_iso8601!()

      assert transmission.state == "scheduled"
    end

    test "create_transmission/1 with invalid data returns error changeset" do
      assert {:error,
              %{
                contents: ["is required"],
                label: ["doesn't allow nil"]
              }} = Communication.schedule_transmission(@invalid_attrs)
    end

    test "change_transmission/1 returns a transmission changeset" do
      transmission = insert(:transmission)
      assert %Ecto.Changeset{} = Communication.change_transmission(transmission)
    end
  end

  describe "messages" do
    alias Adam.Communication.Message

    @update_attrs %{
      type: "sms",
      provider: "wavy",
      sender: "5512987654321",
      receiver: "551298765123"
    }
    @invalid_attrs %{
      type: "type",
      provider: "provider",
      sender: nil,
      receiver: nil
    }

    test "get_message!/1 returns the message with given id" do
      message = insert(:message)
      assert Communication.get_message!(message.id, [:contents]) == message
    end

    test "update_message/2 with valid data updates the message" do
      message = insert(:message)
      assert {:ok, %Message{} = message} = Communication.update_message(message, @update_attrs)
      assert message.provider == "wavy"
      assert message.receiver == "551298765123"
      assert message.sender == "5512987654321"
      assert message.type == "sms"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = insert(:message)
      assert {:error, %Ecto.Changeset{}} = Communication.update_message(message, @invalid_attrs)
      assert message == Communication.get_message!(message.id, [:contents])
    end

    test "change_message/1 returns a message changeset" do
      message = insert(:message)
      assert %Ecto.Changeset{} = Communication.change_message(message)
    end
  end
end
