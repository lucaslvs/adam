defmodule AdamWeb.ErrorViewTest do
  use AdamWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(AdamWeb.ErrorView, "404.json", []) == %{error: "Not Found"}
  end

  test "renders 500.json" do
    assert render(AdamWeb.ErrorView, "500.json", []) == %{error: "Internal Server Error"}
  end
end
