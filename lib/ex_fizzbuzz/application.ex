defmodule ExFizzbuzz.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # Read port from envirronement variable
    port =
      case System.get_env("FIZZBUZZ_PORT") do
        nil -> 8080
        port -> port
      end

    # List all child processes to be supervised
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, ExFizzbuzz.Router, [], port: port)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExFizzbuzz.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
