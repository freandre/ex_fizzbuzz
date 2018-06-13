defmodule ExFizzbuzzTest do
  use ExUnit.Case
  doctest Controllers.FizzBuzz

  test "Standard parameters" do
    assert Controllers.FizzBuzz.fizzbuzz(%{}) == [
             "1",
             "2",
             "fizz",
             "4",
             "buzz",
             "fizz",
             "7",
             "8",
             "fizz",
             "buzz",
             "11",
             "fizz",
             "13",
             "14",
             "fizzbuzz",
             "16",
             "17",
             "fizz",
             "19",
             "buzz",
             "fizz",
             "22",
             "23",
             "fizz",
             "buzz",
             "26",
             "fizz",
             "28",
             "29",
             "fizzbuzz",
             "31",
             "32",
             "fizz",
             "34",
             "buzz",
             "fizz",
             "37",
             "38",
             "fizz",
             "buzz",
             "41",
             "fizz",
             "43",
             "44",
             "fizzbuzz",
             "46",
             "47",
             "fizz",
             "49",
             "buzz",
             "fizz",
             "52",
             "53",
             "fizz",
             "buzz",
             "56",
             "fizz",
             "58",
             "59",
             "fizzbuzz",
             "61",
             "62",
             "fizz",
             "64",
             "buzz",
             "fizz",
             "67",
             "68",
             "fizz",
             "buzz",
             "71",
             "fizz",
             "73",
             "74",
             "fizzbuzz",
             "76",
             "77",
             "fizz",
             "79",
             "buzz",
             "fizz",
             "82",
             "83",
             "fizz",
             "buzz",
             "86",
             "fizz",
             "88",
             "89",
             "fizzbuzz",
             "91",
             "92",
             "fizz",
             "94",
             "buzz",
             "fizz",
             "97",
             "98",
             "fizz",
             "buzz"
           ]
  end

  test "Sepcific parameters" do
    assert Controllers.FizzBuzz.fizzbuzz(%{
             "int1" => 2,
             "string1" => "fiz",
             "int2" => 7,
             "string2" => "buz",
             "limit" => 30
           }) ==
             [
               "1",
               "fiz",
               "3",
               "fiz",
               "5",
               "fiz",
               "buz",
               "fiz",
               "9",
               "fiz",
               "11",
               "fiz",
               "13",
               "fizbuz",
               "15",
               "fiz",
               "17",
               "fiz",
               "19",
               "fiz",
               "buz",
               "fiz",
               "23",
               "fiz",
               "25",
               "fiz",
               "27",
               "fizbuz",
               "29",
               "fiz"
             ]
  end

  test "Sepcific parameters with default value" do
    assert Controllers.FizzBuzz.fizzbuzz(%{"string1" => "fiz", "string2" => "buz", "limit" => 30}) ==
             [
               "1",
               "2",
               "fiz",
               "4",
               "buz",
               "fiz",
               "7",
               "8",
               "fiz",
               "buz",
               "11",
               "fiz",
               "13",
               "14",
               "fizbuz",
               "16",
               "17",
               "fiz",
               "19",
               "buz",
               "fiz",
               "22",
               "23",
               "fiz",
               "buz",
               "26",
               "fiz",
               "28",
               "29",
               "fizbuz"
             ]
  end

  test "Exception on type integer" do
    assert_raise Controllers.FizzBuzz.TypeError,
                 "int1 is not a valid integer.",
                 fn -> Controllers.FizzBuzz.fizzbuzz(%{"int1" => "toto"}) end
  end

  test "Exception on type float" do
    assert_raise Controllers.FizzBuzz.TypeError,
                 "int1 is not a valid integer.",
                 fn -> Controllers.FizzBuzz.fizzbuzz(%{"int1" => 80.80}) end
  end

  test "Exception on negative number" do
    assert_raise Controllers.FizzBuzz.NegativeNumberError,
                 "int2 is negative, which is not allowed.",
                 fn -> Controllers.FizzBuzz.fizzbuzz(%{"int2" => -2}) end
  end

  test "Exception on out of bound limit 42_000" do
    assert_raise Controllers.FizzBuzz.LimitError,
                 "Limit field out of bound 1..1000",
                 fn -> Controllers.FizzBuzz.fizzbuzz(%{"limit" => 42_000}) end
  end

  test "Exception on out of bound limit 0" do
    assert_raise Controllers.FizzBuzz.LimitError,
                 "Limit field out of bound 1..1000",
                 fn -> Controllers.FizzBuzz.fizzbuzz(%{"limit" => 0}) end
  end
end
