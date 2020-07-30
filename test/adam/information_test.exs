defmodule Adam.InformationTest do
  use Adam.DataCase

  alias Adam.Information

  describe "transmission_states" do
    alias Adam.Information.State

    @valid_attrs %{value: "some value"}
    @update_attrs %{value: "some updated value"}
    @invalid_attrs %{value: nil}

    def transmission_state_fixture(attrs \\ %{}) do
      {:ok, transmission_state} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Information.create_transmission_state()

      transmission_state
    end

    test "list_transmission_states/0 returns all transmission_states" do
      transmission_state = transmission_state_fixture()
      assert Information.list_transmission_states() == [transmission_state]
    end

    test "get_transmission_state!/1 returns the transmission_state with given id" do
      transmission_state = transmission_state_fixture()
      assert Information.get_transmission_state!(transmission_state.id) == transmission_state
    end

    test "create_transmission_state/1 with valid data creates a transmission_state" do
      assert {:ok, %State{} = transmission_state} =
               Information.create_transmission_state(@valid_attrs)

      assert transmission_state.value == "some value"
    end

    test "create_transmission_state/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Information.create_transmission_state(@invalid_attrs)
    end

    test "update_transmission_state/2 with valid data updates the transmission_state" do
      transmission_state = transmission_state_fixture()

      assert {:ok, %State{} = transmission_state} =
               Information.update_transmission_state(transmission_state, @update_attrs)

      assert transmission_state.value == "some updated value"
    end

    test "update_transmission_state/2 with invalid data returns error changeset" do
      transmission_state = transmission_state_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Information.update_transmission_state(transmission_state, @invalid_attrs)

      assert transmission_state == Information.get_transmission_state!(transmission_state.id)
    end

    test "delete_transmission_state/1 deletes the transmission_state" do
      transmission_state = transmission_state_fixture()

      assert {:ok, %State{}} =
               Information.delete_transmission_state(transmission_state)

      assert_raise Ecto.NoResultsError, fn ->
        Information.get_transmission_state!(transmission_state.id)
      end
    end

    test "change_transmission_state/1 returns a transmission_state changeset" do
      transmission_state = transmission_state_fixture()
      assert %Ecto.Changeset{} = Information.change_transmission_state(transmission_state)
    end
  end
end
