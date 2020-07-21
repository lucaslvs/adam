defmodule Adam.CommunicationTest do
  use Adam.DataCase

  alias Adam.Communication

  describe "transmissions" do
    alias Adam.Communication.Transmission

    @valid_attrs %{label: "some label", scheduled_at: ~N[2010-04-17 14:00:00], state: "some state"}
    @update_attrs %{label: "some updated label", scheduled_at: ~N[2011-05-18 15:01:01], state: "some updated state"}
    @invalid_attrs %{label: nil, scheduled_at: nil, state: nil}

    def transmission_fixture(attrs \\ %{}) do
      {:ok, transmission} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Communication.create_transmission()

      transmission
    end

    test "list_transmissions/0 returns all transmissions" do
      transmission = transmission_fixture()
      assert Communication.list_transmissions() == [transmission]
    end

    test "get_transmission!/1 returns the transmission with given id" do
      transmission = transmission_fixture()
      assert Communication.get_transmission!(transmission.id) == transmission
    end

    test "create_transmission/1 with valid data creates a transmission" do
      assert {:ok, %Transmission{} = transmission} = Communication.create_transmission(@valid_attrs)
      assert transmission.label == "some label"
      assert transmission.scheduled_at == ~N[2010-04-17 14:00:00]
      assert transmission.state == "some state"
    end

    test "create_transmission/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Communication.create_transmission(@invalid_attrs)
    end

    test "update_transmission/2 with valid data updates the transmission" do
      transmission = transmission_fixture()
      assert {:ok, %Transmission{} = transmission} = Communication.update_transmission(transmission, @update_attrs)
      assert transmission.label == "some updated label"
      assert transmission.scheduled_at == ~N[2011-05-18 15:01:01]
      assert transmission.state == "some updated state"
    end

    test "update_transmission/2 with invalid data returns error changeset" do
      transmission = transmission_fixture()
      assert {:error, %Ecto.Changeset{}} = Communication.update_transmission(transmission, @invalid_attrs)
      assert transmission == Communication.get_transmission!(transmission.id)
    end

    test "delete_transmission/1 deletes the transmission" do
      transmission = transmission_fixture()
      assert {:ok, %Transmission{}} = Communication.delete_transmission(transmission)
      assert_raise Ecto.NoResultsError, fn -> Communication.get_transmission!(transmission.id) end
    end

    test "change_transmission/1 returns a transmission changeset" do
      transmission = transmission_fixture()
      assert %Ecto.Changeset{} = Communication.change_transmission(transmission)
    end
  end
end
