defmodule ExFizzbuzz.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # Read port from envirronement variable
    port = get_port()

    # List all child processes to be supervised
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, ExFizzbuzz.Router, [], port: port)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExFizzbuzz.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Read port from envirronment variable
  defp get_port() do
    case System.get_env("FIZZBUZZ_PORT") do
      nil -> 8080
      port -> port |> parse_port
    end
  end

  # Parse port and ensure it is valid
  defp parse_port(port) do
    case Integer.parse(port) do
      {port, ""} -> port |> validate_port
      _ -> critical_issue("FIZZBUZZ_PORT is not a valid integer")
    end
  end

  # Ensure port is valid
  defp validate_port(port) when port < 0,
    do: critical_issue("FIZZBUZZ_PORT is a negative integer")

  defp validate_port(port) when port > 65_535, do: critical_issue("FIZZBUZZ_PORT is out of bound")
  defp validate_port(port) when port < 1024, do: critical_issue("FIZZBUZZ_PORT is a root port")
  defp validate_port(port), do: port

  # Print an error message and stop the vm
  defp critical_issue(message) do
    IO.puts(message)
    System.stop(1)
  end
end
