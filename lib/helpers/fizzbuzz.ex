defmodule Helpers.Fizzbuzz do
  @defaults [int1: 3, string1: "fizz", int2: 5, string2: "buzz", limit: 100]

  @doc """
  Regular fizz buzz helper:
  all multiples of int1 are replaced by string1,
  all multiples of int2 are replaced by string2,
  all multiples of int1 and int2 are replaced by string1string2

  returns a list of string
  """

  def fizzbuzz(parameters \\ @defaults) do
    [int1: int1, string1: string1, int2: int2, string2: string2, limit: limit] =
      @defaults
      |> Keyword.merge(parameters)

    1..limit
    |> Enum.map(&replace(&1, int1, string1, int2, string2))
  end

  @doc """
    Return parameters defaults values
  """
  def get_defaults, do: @defaults

  defp replace(num, int1, string1, int2, string2) when rem(num, int1 * int2) == 0,
    do: string1 <> string2

  defp replace(num, int1, string1, _int2, _string2) when rem(num, int1) == 0, do: string1
  defp replace(num, _int1, _string1, int2, string2) when rem(num, int2) == 0, do: string2
  defp replace(num, _int1, _string1, _int2, _string2), do: Integer.to_string(num)
end
