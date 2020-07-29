{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.start(formatters: [ExUnit.CLIFormatter, Xcribe.Formatter])
Ecto.Adapters.SQL.Sandbox.mode(Adam.Repo, :manual)
