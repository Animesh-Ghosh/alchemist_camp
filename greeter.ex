defmodule Greeter do
  @author "Animesh"

  def greet do
    name = IO.gets("Hi, what's your name?: ") |> String.trim()

    if name == @author do
      "Hello, creator!"
    else
      "Hello, #{name}"
    end
  end
end
