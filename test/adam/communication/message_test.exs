defmodule Adam.Communication.MessageTest do
  use Adam.DataCase

  import Adam.Factory

  alias Adam.Communication.Message

  describe "changeset/2" do
    @valid_email_attrs %{
      contents: %{subject: "some subject"},
      type: "email",
      provider: "sendgrid",
      sender: "sender@email.com",
      receiver: "receiver@email.com"
    }
    @invalid_email_attrs %{
      contents: %{key: "value"},
      type: "email",
      provider: "provider",
      sender: "sender@email.com",
      receiver: "receiver@email.com"
    }

    setup do
      {:ok, message: struct!(Message)}
    end

    test "should returns a valid message", %{message: message} do
      changeset = Message.changeset(message, @valid_email_attrs)

      assert %Ecto.Changeset{valid?: true} = changeset
    end

    test "should returns a changeset with errors", %{message: message} do
      changeset = Message.changeset(message, @invalid_email_attrs)

      assert %Ecto.Changeset{valid?: false} = changeset
    end
  end

  describe "is_pending?/1" do
    setup do
      messages = [
        insert(:message, state: "pending"),
        insert(:message, state: "sending"),
        insert(:message, state: "sent"),
        insert(:message, state: "delivered"),
        insert(:message, state: "undelivered"),
        insert(:message, state: "received"),
        insert(:message, state: "unreceived"),
        insert(:message, state: "interacted"),
        insert(:message, state: "canceled"),
        insert(:message, state: "failed")
      ]

      {:ok, messages: messages}
    end

    test "should returns true when receive a message with 'pending' state", %{
      messages: [message | _]
    } do
      assert Message.is_pending?(message)
    end

    test "should returns false when receive a message without 'pending' state", %{
      messages: [_ | messages]
    } do
      Enum.each(messages, fn message ->
        refute Message.is_pending?(message)
      end)
    end
  end

  describe "is_sending?/1" do
    setup do
      messages = [
        insert(:message, state: "sending"),
        insert(:message, state: "pending"),
        insert(:message, state: "sent"),
        insert(:message, state: "delivered"),
        insert(:message, state: "undelivered"),
        insert(:message, state: "received"),
        insert(:message, state: "unreceived"),
        insert(:message, state: "interacted"),
        insert(:message, state: "canceled"),
        insert(:message, state: "failed")
      ]

      {:ok, messages: messages}
    end

    test "should returns true when receive a message with 'sending' state", %{
      messages: [message | _]
    } do
      assert Message.is_sending?(message)
    end

    test "should returns false when receive a message without 'sending' state", %{
      messages: [_ | messages]
    } do
      Enum.each(messages, fn message ->
        refute Message.is_sending?(message)
      end)
    end
  end

  describe "is_sent?/1" do
    setup do
      messages = [
        insert(:message, state: "sent"),
        insert(:message, state: "sending"),
        insert(:message, state: "pending"),
        insert(:message, state: "delivered"),
        insert(:message, state: "undelivered"),
        insert(:message, state: "received"),
        insert(:message, state: "unreceived"),
        insert(:message, state: "interacted"),
        insert(:message, state: "canceled"),
        insert(:message, state: "failed")
      ]

      {:ok, messages: messages}
    end

    test "should returns true when receive a message with 'sent' state", %{
      messages: [message | _]
    } do
      assert Message.is_sent?(message)
    end

    test "should returns false when receive a message without 'sent' state", %{
      messages: [_ | messages]
    } do
      Enum.each(messages, fn message ->
        refute Message.is_sent?(message)
      end)
    end
  end

  describe "is_delivered?/1" do
    setup do
      messages = [
        insert(:message, state: "delivered"),
        insert(:message, state: "sent"),
        insert(:message, state: "sending"),
        insert(:message, state: "pending"),
        insert(:message, state: "undelivered"),
        insert(:message, state: "received"),
        insert(:message, state: "unreceived"),
        insert(:message, state: "interacted"),
        insert(:message, state: "canceled"),
        insert(:message, state: "failed")
      ]

      {:ok, messages: messages}
    end

    test "should returns true when receive a message with 'delivered' state", %{
      messages: [message | _]
    } do
      assert Message.is_delivered?(message)
    end

    test "should returns false when receive a message without 'delivered' state", %{
      messages: [_ | messages]
    } do
      Enum.each(messages, fn message ->
        refute Message.is_delivered?(message)
      end)
    end
  end

  describe "is_undelivered?/1" do
    setup do
      messages = [
        insert(:message, state: "undelivered"),
        insert(:message, state: "delivered"),
        insert(:message, state: "sent"),
        insert(:message, state: "sending"),
        insert(:message, state: "pending"),
        insert(:message, state: "received"),
        insert(:message, state: "unreceived"),
        insert(:message, state: "interacted"),
        insert(:message, state: "canceled"),
        insert(:message, state: "failed")
      ]

      {:ok, messages: messages}
    end

    test "should returns true when receive a message with 'undelivered' state", %{
      messages: [message | _]
    } do
      assert Message.is_undelivered?(message)
    end

    test "should returns false when receive a message without 'undelivered' state", %{
      messages: [_ | messages]
    } do
      Enum.each(messages, fn message ->
        refute Message.is_undelivered?(message)
      end)
    end
  end

  describe "is_received?/1" do
    setup do
      messages = [
        insert(:message, state: "received"),
        insert(:message, state: "undelivered"),
        insert(:message, state: "delivered"),
        insert(:message, state: "sent"),
        insert(:message, state: "sending"),
        insert(:message, state: "pending"),
        insert(:message, state: "unreceived"),
        insert(:message, state: "interacted"),
        insert(:message, state: "canceled"),
        insert(:message, state: "failed")
      ]

      {:ok, messages: messages}
    end

    test "should returns true when receive a message with 'received' state", %{
      messages: [message | _]
    } do
      assert Message.is_received?(message)
    end

    test "should returns false when receive a message without 'received' state", %{
      messages: [_ | messages]
    } do
      Enum.each(messages, fn message ->
        refute Message.is_received?(message)
      end)
    end
  end

  describe "is_unreceived?/1" do
    setup do
      messages = [
        insert(:message, state: "unreceived"),
        insert(:message, state: "received"),
        insert(:message, state: "undelivered"),
        insert(:message, state: "delivered"),
        insert(:message, state: "sent"),
        insert(:message, state: "sending"),
        insert(:message, state: "pending"),
        insert(:message, state: "interacted"),
        insert(:message, state: "canceled"),
        insert(:message, state: "failed")
      ]

      {:ok, messages: messages}
    end

    test "should returns true when receive a message with 'unreceived' state", %{
      messages: [message | _]
    } do
      assert Message.is_unreceived?(message)
    end

    test "should returns false when receive a message without 'unreceived' state", %{
      messages: [_ | messages]
    } do
      Enum.each(messages, fn message ->
        refute Message.is_unreceived?(message)
      end)
    end
  end

  describe "is_interacted?/1" do
    setup do
      messages = [
        insert(:message, state: "interacted"),
        insert(:message, state: "unreceived"),
        insert(:message, state: "received"),
        insert(:message, state: "undelivered"),
        insert(:message, state: "delivered"),
        insert(:message, state: "sent"),
        insert(:message, state: "sending"),
        insert(:message, state: "pending"),
        insert(:message, state: "canceled"),
        insert(:message, state: "failed")
      ]

      {:ok, messages: messages}
    end

    test "should returns true when receive a message with 'interacted' state", %{
      messages: [message | _]
    } do
      assert Message.is_interacted?(message)
    end

    test "should returns false when receive a message without 'interacted' state", %{
      messages: [_ | messages]
    } do
      Enum.each(messages, fn message ->
        refute Message.is_interacted?(message)
      end)
    end
  end

  describe "is_canceled?/1" do
    setup do
      messages = [
        insert(:message, state: "canceled"),
        insert(:message, state: "sending"),
        insert(:message, state: "pending"),
        insert(:message, state: "sent"),
        insert(:message, state: "delivered"),
        insert(:message, state: "undelivered"),
        insert(:message, state: "received"),
        insert(:message, state: "unreceived"),
        insert(:message, state: "interacted"),
        insert(:message, state: "failed")
      ]

      {:ok, messages: messages}
    end

    test "should returns true when receive a message with 'canceled' state", %{
      messages: [message | _]
    } do
      assert Message.is_canceled?(message)
    end

    test "should returns false when receive a message without 'canceled' state", %{
      messages: [_ | messages]
    } do
      Enum.each(messages, fn message ->
        refute Message.is_canceled?(message)
      end)
    end
  end

  describe "is_failed?/1" do
    setup do
      messages = [
        insert(:message, state: "failed"),
        insert(:message, state: "canceled"),
        insert(:message, state: "sending"),
        insert(:message, state: "pending"),
        insert(:message, state: "sent"),
        insert(:message, state: "delivered"),
        insert(:message, state: "undelivered"),
        insert(:message, state: "received"),
        insert(:message, state: "unreceived"),
        insert(:message, state: "interacted")
      ]

      {:ok, messages: messages}
    end

    test "should returns true when receive a message with 'failed' state", %{
      messages: [message | _]
    } do
      assert Message.is_failed?(message)
    end

    test "should returns false when receive a message without 'failed' state", %{
      messages: [_ | messages]
    } do
      Enum.each(messages, fn message ->
        refute Message.is_failed?(message)
      end)
    end
  end
end
