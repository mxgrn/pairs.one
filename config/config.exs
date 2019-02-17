# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :pairs_one, PairsOneWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "y8VnQ8XolfdTMIrVKP+Z2iNuZL6WJfbgAqMxna1qjLYVgOnVlrIQcBr44YyaU3ZB",
  render_errors: [view: PairsOneWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PairsOne.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :pairs_one, PairsOneWeb.Gettext, locales: ~w(en ru fr uk pt)

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

if File.exists?("#{Path.dirname(__ENV__.file)}/#{Mix.env()}.local.exs") do
  import_config "#{Mix.env()}.local.exs"
end
