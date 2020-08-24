defmodule Mix.Tasks.App do
  def run(_) do
    IO.puts("#{app_name()}:#{app_version()}")
  end

  def app_name() do
    Mix.Project.config()[:app] |> Atom.to_string()
  end

  def app_version() do
    Mix.Project.config()[:version]
  end
end

defmodule Mix.Tasks.App.Name do
  def run(_) do
    IO.puts(Mix.Tasks.App.app_name())
  end
end

defmodule Mix.Tasks.App.Version do
  def run(_) do
    IO.puts(Mix.Tasks.App.app_version())
  end
end
