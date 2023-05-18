defmodule Tictac do
  @players {:x, :o}

  def check_player(player) do
    case player do
      :x -> {:ok, player}
      :o -> {:ok, player}
      _ -> {:error, :invalid_player}
    end
  end

  def place_piece(board, place, player) do
    case board[place] do
      nil -> {:error, :invalid_location}
      :x -> {:error, :occupied}
      :o -> {:error, :occupied}
      :empty -> {:ok, %{board | place => player}}
    end
  end

  def play_at(board, row, col, player) do
    with {:ok, valid_player} <- check_player(player),
         {:ok, square} <- Square.new(row, col),
         {:ok, new_board} <- place_piece(board, square, valid_player),
         do: new_board
  end

  def new_board do
    for square <- squares(), into: %{}, do: {square, :empty}
  end

  def squares do
    for row <- 1..3, col <- 1..3, into: MapSet.new(), do: %Square{row: row, col: col}
  end
end
