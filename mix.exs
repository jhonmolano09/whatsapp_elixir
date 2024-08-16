defmodule WhatsappElixir.MixProject do
  use Mix.Project

  @version "0.1.0"
  @repo_url "https://github.com/Maxino22/whatsapp_elixir"

  def project do
    [
      app: :whatsapp_elixir,
      version: @version,
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

        # Hex
      description: "Open source Elixir wrapper for the WhatsApp Cloud API",
      package: package(),

        # Docs
      name: "whatsapp_elixir",
      docs: [
          name: "whatsapp_elixir",
          source_ref: "v#{@version}",
          source_url: @repo_url,
          homepage_url: @repo_url,
          main: "readme",
          extras: ["README.md"],
          links: %{
            "GitHub" => @repo_url,
            "Sponsor" => "https://github.com/sponsors/Maxino22"
          }
        ]
      ]

  end

  def package do
    [
    licenses: ["MIT"],
    # links: %{"GitHub" => "https://github.com/yourusername/whatsapp_elixir"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:req, "~> 0.3"},
      {:jason, "~> 1.4"},
      {:ex_doc, "~> 0.27.0", only: :dev, runtime: false}
    ]
  end
end
