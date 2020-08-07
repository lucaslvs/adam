defmodule AdamWeb.V1.ContentView do
  use AdamWeb, :view
  alias AdamWeb.V1.ContentView

  def render("contents.json", %{contents: contents}) do
    render_many_contents(contents)
  end

  def render("content.json", %{content: content}) do
    Map.new("#{content.name}": content.value)
  end

  def render_many_contents(contents) when is_list(contents) do
    contents
    |> render_many(ContentView, "content.json")
    |> Enum.reduce(Map.new(), &Map.merge(&2, &1))
  end

  def render_many_contents(_contents), do: []
end
