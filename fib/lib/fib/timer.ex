defmodule Fib.Timer do
  def time(func, args) do
    start = Time.utc_now()
    apply(func, args)
    Time.diff(Time.utc_now(), start, :millisecond)
  end
end
