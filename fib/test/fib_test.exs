defmodule FibTest do
  use ExUnit.Case
  doctest Fib

  test "naive fibonacci base cases" do
    assert Fib.naive(1) == 0
    assert Fib.naive(2) == 1
  end

  test "naive fibonacci other numbers" do
    assert Fib.naive(6) == 5
    assert Fib.naive(7) == 8
    assert Fib.naive(17) == 987
  end

  test "faster fibonacci base cases" do
    assert Fib.faster(1) == 0
    assert Fib.faster(2) == 1
  end

  test "faster fibonacci other numbers" do
    assert Fib.faster(6) == 5
    assert Fib.faster(7) == 8
    assert Fib.faster(17) == 987
  end

  test "faster fibonacci really large number" do
    assert Fib.faster(150) == 6_161_314_747_715_278_029_583_501_626_149
  end
end
