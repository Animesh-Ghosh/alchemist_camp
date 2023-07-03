defmodule Ch14 do
  def squish([]), do: []
  def squish([head | tail]), do: squish(head) ++ squish(tail)
  def squish(head), do: [head]

  def squash(list), do: squash(list, []) |> Enum.reverse()
  def squash([], acc), do: acc
  def squash([[] | tail], acc), do: squash(tail, acc)

  def squash([head | tail], acc) when is_list(head) do
    squash(tail, squash(head, acc))
  end

  def squash([head | tail], acc), do: squash(tail, [head | acc])
end

import Ch14

list =
  List.duplicate("foo", 50)
  |> List.duplicate(50)
  |> List.duplicate(50)
  |> List.duplicate(50)

{time_1, _} = :timer.tc(fn -> squish(list) end)
{time_2, _} = :timer.tc(fn -> squash(list) end)

IO.puts("squish took #{time_1}")
IO.puts("squash took #{time_2}")
IO.puts("squash #{time_1 / time_2} times faster")
