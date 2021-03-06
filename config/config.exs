# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :drops,
  ecto_repos: [Drops.Repo]

# Configures the endpoint
config :drops, DropsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "XjFY2RUeUM5jKnPrpbkvZCuh85cBEgsV5DPzIjFOTOR1t0INWaQYqB53D3XtmlOw",
  render_errors: [view: DropsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Drops.PubSub,
  live_view: [signing_salt: "1j8NZgI3"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
