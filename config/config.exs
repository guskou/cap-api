# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :cap,
  ecto_repos: [Cap.Repo]

# Configures the endpoint
config :cap, Cap.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "pEgAriV7QNhoFf55+cGMNGN4lFjkLbFzreNggYeqSX2nF9Gn6PDgFftKqrZz6k6c",
  render_errors: [view: Cap.ErrorView, accepts: ~w(json)],
  pubsub: [name: Cap.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :format_encoders,
  "json-api": Poison

config :plug, :mimes, %{
  "application/vnd.api+json" => ["json-api"]
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
