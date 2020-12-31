defmodule Clock.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: Clock.Supervisor]

    Supervisor.start_link(children(target(), env()), opts)
  end

  # List all child processes to be supervised
  def children(_target, :test) do
    []
  end

  def children(_target, _other) do
    [{Clock.Server, Application.get_all_env(:clock)}]
  end

  defp target() do
    Application.get_env(:clock, :target)
  end

  defp env() do
    Mix.env()
  end
end
