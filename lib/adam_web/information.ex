defmodule AdamWeb.Information do
  use Xcribe.Information

  xcribe_info do
    name("Adam REST API")

    description("""
      Adam is a microsservice specializing in seending communications transmision accross multiple channells and their providers,
      allowing you to track all events emmited by these channels, giving the customer total control over how their communications
      behave after the are sent.
    """)

    host(System.get_env("HOST", "http://localhost:4000/api/v1"))
  end
end
