# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :pairs_one, :env, Mix.env()

# Configures the endpoint
config :pairs_one, PairsOneWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  render_errors: [view: PairsOneWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: PairsOne.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :logger,
  backends: [:console, Sentry.LoggerBackend]

config :pairs_one, PairsOneWeb.Gettext, locales: ~w(en es ru fr uk pt)

config :pairs_one, :release_sha, System.get_env("GITHUB_SHA") || "?"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

if File.exists?("#{Path.dirname(__ENV__.file)}/#{Mix.env()}.local.exs") do
  import_config "#{Mix.env()}.local.exs"
end
