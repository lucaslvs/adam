defmodule Adam.MixProject do
  use Mix.Project

  def project do
    [
      app: :adam,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.html": :test
      ],
      name: "Adam",
      source_url: "https://github.com/lucaslvs/adam",
      docs: docs(),
      description: """
      Adam is a microservice specializing in sending communications transmission across multiple channels and their providers.
      """
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Adam.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.4"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_live_dashboard, "~> 0.2"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:machinery, "~> 1.0.0"},
      {:ex_machina, "~> 2.4"},
      {:scrivener_ecto, "~> 2.0"},
      {:casex, "~> 0.4.0"},
      {:xcribe, "~> 0.7.3"},
      {:ex_doc, "~> 0.22.2", only: :dev, runtime: false},
      {:excoveralls, "~> 0.13.1", only: :test}
    ]
  end

  # Specifies the project documentation structure.
  # For generate project documentation, run:
  #
  #     $ mix docs
  #
  # To see all options available when generating docs, run `mix help docs`.
  defp docs do
    [
      main: "Adam",
      groups_for_modules: groups_for_modules(),
      extras: extras(),
      groups_for_extras: groups_for_extras()
    ]
  end

  defp extras do
    [
      "guides/introduction/overview.md",
      "guides/introduction/installation.md",
      "guides/introduction/up_and_running.md",
      "guides/directory_structure.md",
      "guides/mix_tasks.md",
      "guides/development.md",
      "guides/testing.md",
      "guides/deployment/deployment.md",
      "guides/deployment/releases.md",
      "guides/troubleshooting/postback_configuration.md"
    ]
  end

  defp groups_for_extras do
    [
      Introduction: ~r/guides\/introduction\/.?/,
      Guides: ~r/guides\/[^\/]+\.md/,
      Deployment: ~r/guides\/deployment\/.?/,
      Troubleshooting: ~r/guides\/troubleshooting\/.?/
    ]
  end

  defp groups_for_modules do
    [
      Core: [
        Adam.Repo,
        Adam.PubSub,
        Adam.Communication,
        Adam.Information
      ],
      Communication: [
        Adam.Communication.Transmission,
        Adam.Communication.Message,
        Adam.Communication.Content
      ],
      Information: [
        Adam.Information.State
      ],
      Web: [
        AdamWeb,
        AdamWeb.Gettext,
        AdamWeb.ErrorHelpers,
        AdamWeb.FallbackController
      ]
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
