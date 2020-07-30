defmodule Adam do
  @moduledoc """
  Adam keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def pub_sub do
    quote do
      import Adam.PubSub
    end
  end

  @doc """
  When used, dispatch to the appropriate pub_sub.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
