defmodule Packerbench.MixProject do
  use Mix.Project

  def project do
    [
      app: :packerbench,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      #mod: {Packerbench, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:benchee, "~> 0.13.0"},
      {:benchee_html, "~> 0.5"},
      #{:tap, "~> 0.1.5"},
      {:exprof, "~> 0.2.3"},
      {:packer, path: "../packer-dev"}
    ]
  end
end
