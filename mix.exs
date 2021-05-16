defmodule TheBardBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :the_bard_bot,
      version: "0.1.9",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        default: [
          include_executables_for: [:unix],
          steps: [:assemble, &copy_extra_files/1]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TheBardBot, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.0"},
      {:mint, "~> 1.0"},
      {:castore, "~> 0.0"},
      {:mox, "~> 0.0", only: :test},
      {:erlport, "~> 0.10"}
    ]
  end

  defp copy_extra_files(release) do
    ["assets"]
    |> Enum.each(fn f -> File.cp_r(f, Path.join(release.path, f)) end)

    release
  end
end
