# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :adam,
  ecto_repos: [Adam.Repo]

# Configures the endpoint
config :adam, AdamWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "jpLEV1SdzjB9c6CabTcAeNy4+o4s6w+IK7deG2iVmN5ddlNYdk2hrq4hlugIVvA/",
  render_errors: [view: AdamWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Adam.PubSub,
  live_view: [signing_salt: "vbZCjjfm"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Use Casex to encode with Camel Case
config :phoenix, format_encoders, json: Casex.CamelCaseEncoder

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
