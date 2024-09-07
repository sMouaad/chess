# frozen_string_literal: true

require_relative '../piece'
# Knight class for the knight piece
class Knight < Piece
  attr_reader :symbol, :notation

  MOVES_OFFSETS = [1, -1].product([2, -2]) + [2, -2].product([1, -1])
  def initialize(color, coordinates)
    super
    @symbol = Piece::PIECES[:knight].colorize(color)
    @notation = 'N'
  end

  # Calculate possible next moves in current position
  def calculate_next_moves(board)
    moves = []
    row, column = to_index(coordinates)
    MOVES_OFFSETS.each do |offset|
      final_position = [row + offset.first, column + offset.last]
      moves << final_position if correct_index?(final_position) && (empty_square?(board,
                                                                                  final_position) || enemy_square?(
                                                                                    board, final_position
                                                                                  ))
    end
    moves
  end
end
