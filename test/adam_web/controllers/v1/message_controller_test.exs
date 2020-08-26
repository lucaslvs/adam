defmodule AdamWeb.V1.MessageControllerTest do
  use AdamWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all messages", %{conn: conn} do
      conn = get(conn, Routes.v1_message_path(conn, :index))

      assert json_response(conn, 200) == %{
               "messages" => [],
               "pageNumber" => 1,
               "pageSize" => 20,
               "totalPages" => 1,
               "totalMessages" => 0
             }
    end
  end
end
