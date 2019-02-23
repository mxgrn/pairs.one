defmodule PairsOne.Mixfile do
  use Mix.Project

  def project do
    [
      app: :pairs_one,
      version: "0.0.1",
      elixir: "~> 1.2",
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
      mod: {PairsOne, []},
      applications: [
        :phoenix,
        :phoenix_pubsub,
        :phoenix_html,
        :cowboy,
        :logger,
        :gettext,
        :uuid,
        :exredis,
        :lz_string,
        :edeliver,
        :httpotion
      ]
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
      {:phoenix, "~> 1.3.2"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.13"},
      {:cowboy, "~> 1.0"},
      {:uuid, "~> 1.1"},
      {:edeliver, "~> 1.4.0"},
      {:distillery, "~> 1.4"},
      {:exredis, ">= 0.2.4"},
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:lz_string, "~> 0.0.6"},
      {:httpotion, "~> 3.0.2"}
    ]
  end

  defp aliases do
    [
      compile: ["compile --warnings-as-errors"]
    ]
  end
end
