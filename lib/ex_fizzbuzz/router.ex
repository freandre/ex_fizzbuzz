defmodule ExFizzbuzz.Router do
  @moduledoc """
  Main plug router module. Only /fizzbuzz route is declared, everything else will be
  redirected to the custom 404 message.
  On argument validation for the fizzbuzz route, the error handler display the exception
  message available.
  """

  use Plug.Router
  use Plug.ErrorHandler

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  get "/fizzbuzz" do
    conn = fetch_query_params(conn)

    ret =
      Controllers.FizzBuzz.fizzbuzz(conn.params)
      |> Poison.encode!()

    send_resp(conn, 200, ret)
  end

  match(_, do: send_resp(conn, 404, "Oops! Bad route!!"))

  def handle_errors(conn, %{kind: _kind, reason: reason, stack: _stack}) do
    send_resp(conn, conn.status, reason.message)
  end
end
