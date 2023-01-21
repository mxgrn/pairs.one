defmodule PairsOne.Mixfile do
  use Mix.Project

  def project do
    [
      app: :pairs_one,
      version: "0.0.1",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {PairsOne.Application, []},
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
      {:phoenix, "~> 1.5.6"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.3 or ~> 0.2.9"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.18"},
      {:plug_cowboy, "~> 2.0"},

      # Sentry
      {:sentry, "~> 8.0"},
      {:hackney, "~> 1.8"},

      # DEBT: used in the code
      {:poison, "~> 3.1"},

      # Used by Phoenix
      {:jason, "~> 1.0"},
      {:uuid, "~> 1.1"},
      # {:edeliver, "~> 1.4.0"},
      # {:distillery, "~> 1.5"},
      {:exredis, ">= 0.2.4"},
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:lz_string, "~> 0.0.6"},
      {:httpotion, "~> 3.0.2"},
      {:libcluster, "~> 3.2.1"}
    ]
  end

  defp aliases do
    [
      compile: ["compile --warnings-as-errors"]
    ]
  end
end
