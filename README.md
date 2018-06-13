# ExFizzbuzz

ExFizzbuzz is a simple sandbox application designed to learn some core elixir
concepts by implementing the common FizzBuzz interview problem.

> "Write a program that prints the numbers from 1 to 100. But for multiples of
> three print “Fizz” instead of the number and for the multiples of five print
> “Buzz”. For numbers which are multiples of both three and five print
> “FizzBuzz”."

## Description
Basically, this project is a REST server whose sole purpose is to provide a
`/fizzbuzz` endpoint allowing none or all of the following query parameters:

1. `int1`: the first multiple to find
2. `int2`: the second one...
3. `string2`: the first replacement string
4. `string2`: the second one...
5. `limit`: the upper limit to go

On request, the answer is computed and sent back as a list of string.

## Use
Once the repository cloned, `mix deps.get` to gather third-parties
and `mix run --no-halt` to run the application. Once done, open your browser on
[http://localhost:8080/fizzbuzz](http://localhost:8080/fizzbuzz), the canonical
answer will be displayed. You can now play with the query parameters to see how
they change the answer.

The default port is also configurable thanks to the `FIZZBUZZ_PORT`
environment variable. eg: `FIZZBUZZ_PORT=8181 mix run --no-halt`

This would allow an easy configuration in a Docker container.

## Technic
The used stack is pretty straightforward, the main component is the
[Plug](https://github.com/elixir-plug/plug) library that allows easy HTTP
routing for Elixir. On request, the router try to find a matching route,
forward the connection to the handler which computes the response.

### Supervisor
One of the killer feature of the whole Erlang plateform is its supervisor
framework. A Supervisor, is a standalone process on the Erlang VM that monitors
a given set of children, restarting them automatically in case of crash. This
design of course enforce reliabilty of the whole application.

In this project, the [supervisor](lib/ex_fizzbuzz/application.ex) is in charge
of reading the environment variable FIZZBUZZ_PORT and starting the router.
Once done, the whole application is monitored.

### Router
A [Plug.Router](https://hexdocs.pm/plug/Plug.Router.html#content) is a
Plug component matching an incoming HTTP request to a declared handler.
In this project, the [router](lib/ex_fizzbuzz/router.ex) only accepts the
`/fizzbuzz` endpoint, rejecting everything else with a 404 page.

On internal error, a custom error handler provides informations about the
encountered issue.

### Controller
The [controller](lib/controllers/fizzbuzz.ex), on it side, receives all the
query parameters, reads and formats them, throws errors if they are not
properly set and finally forward options to the FizzBuzz helper.

### Helper
Finally the [helper](lib/helpers/fizzbuzz.ex) is the real processing unit.
This is here that the official problem is solved.

## Test
Elixir comes with a handy set of tools. Amongst them, a unit test framework is
available. Several [tests](test/controller_fizzbuzz_test.exs) can be
implemented to validate that our fantastic application is working as expected.
Just run `mix test` to run the tests.

## Code quality
To enforce code quality the [Dialyzer](http://erlang.org/doc/man/dialyzer.html)
tool has been created for the Erlang plateform. Fortunately its Elixir
counterpart [Dialyxir](https://github.com/jeremyjh/dialyxir) has also be made.
This can be run with the `mix dialyzer` command.

## Deployment
Finally to allow an easy deployment of the project,
[Distillery](https://github.com/bitwalker/distillery) comes to our help.
`MIX_ENV=prod mix release --executable` et voila a fresh all in one binary
embbeding the Erlang runtime.

`==> Release successfully built!
    You can run it in one of the following ways:
      Interactive: _build/prod/rel/ex_fizzbuzz/bin/ex_fizzbuzz.run console
      Foreground: _build/prod/rel/ex_fizzbuzz/bin/ex_fizzbuzz.run foreground
      Daemon: _build/prod/rel/ex_fizzbuzz/bin/ex_fizzbuzz.run start`

 Never the less, Distillery keeps the Erlang ability to hot deploy upgrade
 without stopping the application... neat isn't it ? :)
