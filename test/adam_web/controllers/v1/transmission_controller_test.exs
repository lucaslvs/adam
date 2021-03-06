defmodule AdamWeb.V1.TransmissionControllerTest do
  use AdamWeb.ConnCase

  @create_attrs %{
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
  @invalid_attrs %{
    label: nil,
    scheduled_at: "2010-04-17 14:00:00",
    messages: []
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all transmissions", %{conn: conn} do
      conn = get(conn, Routes.v1_transmission_path(conn, :index))

      assert json_response(conn, 200) == %{
               "transmissions" => [],
               "pageNumber" => 1,
               "pageSize" => 20,
               "totalPages" => 1,
               "totalTransmissions" => 0
             }
    end
  end

  describe "create transmission" do
    test "renders transmission when data is valid", %{conn: conn} do
      conn = post(conn, Routes.v1_transmission_path(conn, :create), transmission: @create_attrs)

      assert %{"id" => id} = json_response(conn, 202)["transmission"]

      conn = get(conn, Routes.v1_transmission_path(conn, :show, id))

      assert %{
               "transmission" => %{
                 "contents" => %{},
                 "id" => id,
                 "label" => "label",
                 "state" => "scheduled",
                 "messages" => [
                   %{
                     "contents" => %{"subject" => "some subject"},
                     "provider" => "sendgrid",
                     "receiver" => "receiver@email.com",
                     "sender" => "sender@email.com",
                     "state" => "pending",
                     "transmissionId" => id,
                     "type" => "email"
                   }
                 ]
               }
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.v1_transmission_path(conn, :create), transmission: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
