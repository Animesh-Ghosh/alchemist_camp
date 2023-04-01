defmodule GuessingGame do
  def mid(low, high) do
    div(low + high, 2)
  end

  def guess(low, high) when low > high, do: guess(high, low)

  def guess(low, high) do
    answer = IO.gets("Are you guessing of #{mid(low, high)}?\n")

    case String.trim(answer) do
      "bigger" ->
        bigger(low, high)

      "smaller" ->
        smaller(low, high)

      "yes" ->
        "Woohoo, I did it!"

      _ ->
        IO.puts(~s{Type "bigger", "smaller" or "yes"})
        guess(low, high)
    end
  end

  def bigger(low, high) do
    new_low = min(high, mid(low, high) + 1)
    guess(new_low, high)
  end

  def smaller(low, high) do
    new_high = max(low, mid(low, high) - 1)
    guess(low, new_high)
  end
end
