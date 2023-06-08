defmodule Square do
  alias __MODULE__
  @enforce_keys [:row, :col]
  defstruct [:row, :col]

  @board_size 1..8

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

  def rook_attacks(board, row, col) do
    for {%{row: r, col: c}, _} = square <- board,
        :erlang.xor(row == r, col == c),
        do: square
  end

  def bishop_attacks(board, row, col) do
    for {%{row: r, col: c}, _} = square <- board,
        :erlang.xor(r - c == row - col, r + c == row + col),
        do: square
  end

  def knight_attacks(board, row, col) do
    for {%{row: r, col: c}, _} = square <- board,
        (abs(row - r) == 1 and abs(col - c) == 2) or
          (abs(row - r) == 2 and abs(col - c) == 1),
        do: square
  end
end
