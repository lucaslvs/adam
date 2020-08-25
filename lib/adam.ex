defmodule Adam do
  @moduledoc """
  Adam keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @doc false
  def service do
    quote do
      use Exop.Operation

      import Ecto.Changeset
      import Exop.Operation

      alias Adam.Repo
      alias Ecto.{Changeset, Multi}
    end
  end

  @doc """
  When used, dispatch to the appropriate service/machinery/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    IO.inspect(which)
    apply(__MODULE__, which, [])
  end
end
