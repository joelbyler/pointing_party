use Mix.Config

config :pointing_party, PointingParty.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "www.pointing-party.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :pointing_party,
  ssl_config: [
    input_sha: System.get_env("SSL_INPUT_SHA"),
    output_sha: System.get_env("SSL_OUTPUT_SHA")
  ]

config :logger, level: :info

config :pointing_party, PointingParty.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true
