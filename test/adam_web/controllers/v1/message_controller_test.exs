defmodule AdamWeb.V1.MessageControllerTest do
  use AdamWeb.ConnCase

  import Adam.Factory

  alias Adam.Communication

  @create_attrs %{
    provider: "some provider",
    receiver: "some receiver",
    sender: "some sender",
    state: "some state",
    type: "some type"
  }
  @invalid_attrs %{provider: nil, receiver: nil, sender: nil, state: nil, type: nil}

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

  defp create_message(_) do
    %{messages: [message | _]} = insert(:transmission)
    %{message: message}
  end
end
