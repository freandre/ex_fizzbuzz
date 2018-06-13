defmodule Controllers.FizzBuzz do
  defmodule NegativeNumberError do
    @moduledoc """
    Error raised when a field is negative is negative
    """
    defexception message: "A negative number is provided", plug_status: 400
  end

  defmodule TypeError do
    @moduledoc """
    Error raised when their is a type error in parameters
    """
    defexception message:
                   "Type error on parameter (usually an expected integer is a string not parseable to integer)",
                 plug_status: 400
  end

  defmodule LimitError do
    @moduledoc """
    Error raised when limit is out of bound 1..1000
    """
    defexception message: "Limit field out of bound 1..1000", plug_status: 400
  end

  @doc """
  Main controller entrypoint. Based on provided query attributes, prepare a list of options,
  send it to the helper and format a json result.

  Supported query parameters:
  int1, int2, string1, string2, limit

  returns a list of string
  """
  def fizzbuzz(%{} = params) do
    reference = Helpers.Fizzbuzz.get_defaults()

    params
    |> get_options(reference)
    |> convert_numerics(reference)
    |> validate_options!(reference)
    |> Helpers.Fizzbuzz.fizzbuzz()
  end

  # Based on reference options and in url ones, prepare option list
  defp get_options(params, reference) do
    reference
    |> Enum.map(fn {key, value} ->
      {key, Map.get(params, to_string(key), value)}
    end)
  end

  # Integer parameters may be provided as string, let's try to convert
  # them to int (according to default values type!!)
  defp convert_numerics(options, reference) do
    options
    |> Enum.map(fn {key, value} -> convert_numeric(key, value, reference[key]) end)
  end

  defp convert_numeric(key, value, ref_value)
       when is_integer(ref_value) and is_bitstring(value) do
    case Integer.parse(value) do
      {x, _} -> {key, x}
      _ -> {key, value}
    end
  end

  defp convert_numeric(key, value, _ref_value), do: {key, value}

  # Check that default values options have the same type as parameters one
  defp validate_options!(opts, reference) do
    reference
    |> Enum.each(fn {key, value} ->
      check_value(key, opts[key], value)
    end)

    opts
  end

  defp check_value(key, value, refvalue) do
    cond do
      is_bitstring(refvalue) and !is_bitstring(value) ->
        raise(TypeError, message: Atom.to_string(key) <> " is not a string.")

      is_integer(refvalue) and !is_integer(value) ->
        raise(TypeError, message: Atom.to_string(key) <> " is not a valid integer.")

      is_integer(value) and value < 0 ->
        raise(
          NegativeNumberError,
          message: Atom.to_string(key) <> " is negative, which is not allowed."
        )

      key == :limit and (value < 1 or value > 1000) ->
        raise LimitError

      true ->
        value
    end
  end
end
