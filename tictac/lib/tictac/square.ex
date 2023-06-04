defmodule Tictac.Square do
  alias Tictac.Square
  @enforce_keys [:row, :col]
  defstruct [:row, :col]

  @board_size 1..3

  def new(row, col) when row in @board_size and col in @board_size do
    {:ok, %Square{row: row, col: col}}
  end

  def new(_row, _col), do: {:error, :invalid_square}

  def new_board do
    for square <- squares(), into: %{}, do: {square, :empty}
  end

  def squares do
    for row <- @board_size,
        col <- @board_size,
        into: MapSet.new(),
        do: %Square{row: row, col: col}
  end
end
