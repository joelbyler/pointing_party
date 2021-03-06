# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :pointing_party,
  ecto_repos: [PointingParty.Repo]

# Configures the endpoint
config :pointing_party, PointingPartyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "VDXcHz4hdCSyx6rtritjotfiX/gKZucTi+ryJaGtjUphndbPRhX4nkjeqwtbr177",
  render_errors: [view: PointingPartyWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PointingParty.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :pointing_party,
  ssl_config: [input_sha: "abc", output_sha: "xyz"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
