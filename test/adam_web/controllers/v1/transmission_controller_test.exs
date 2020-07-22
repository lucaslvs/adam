defmodule AdamWeb.V1.TransmissionControllerTest do
  use AdamWeb.ConnCase

  alias Adam.Communication
  alias Adam.Communication.Transmission

  @create_attrs %{
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

  def fixture(:transmission) do
    {:ok, transmission} = Communication.create_transmission(@create_attrs)
    transmission
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all transmissions", %{conn: conn} do
      conn = get(conn, Routes.v1_transmission_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create transmission" do
    test "renders transmission when data is valid", %{conn: conn} do
      conn = post(conn, Routes.v1_transmission_path(conn, :create), transmission: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.v1_transmission_path(conn, :show, id))

      assert %{
               "id" => id,
               "label" => "some label",
               "scheduled_at" => "2010-04-17T14:00:00",
               "state" => "some state"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.v1_transmission_path(conn, :create), transmission: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update transmission" do
    setup [:create_transmission]

    test "renders transmission when data is valid", %{
      conn: conn,
      transmission: %Transmission{id: id} = transmission
    } do
      conn =
        put(conn, Routes.v1_transmission_path(conn, :update, transmission),
          transmission: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.v1_transmission_path(conn, :show, id))

      assert %{
               "id" => id,
               "label" => "some updated label",
               "scheduled_at" => "2011-05-18T15:01:01",
               "state" => "some updated state"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, transmission: transmission} do
      conn =
        put(conn, Routes.v1_transmission_path(conn, :update, transmission),
          transmission: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete transmission" do
    setup [:create_transmission]

    test "deletes chosen transmission", %{conn: conn, transmission: transmission} do
      conn = delete(conn, Routes.v1_transmission_path(conn, :delete, transmission))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.v1_transmission_path(conn, :show, transmission))
      end
    end
  end

  defp create_transmission(_) do
    transmission = fixture(:transmission)
    %{transmission: transmission}
  end
end
