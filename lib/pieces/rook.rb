require_relative '../piece'

class Rook < Piece
  attr_reader :symbol

  MOVES_OFFSETS = [[0, 1], [0, -1], [1, 0], [-1, 0]].freeze
  def initialize(color, position)
    super
    @symbol = Piece::PIECES[:rook].colorize(color)
  end

  def next_moves
    moves = []
    row, column = to_index(coordinates)
    MOVES_OFFSETS.each do |move|
      offset_row, offset_column = move
      next_position = [row + offset_row, column + offset_column]

      # Yield it to board for additional checks depending on board
      while correct_index?(next_position) && yield(next_position)
        moves << next_position
        offset_row += move.first
        offset_column += move.last
        next_position = [row + offset_row, column + offset_column]
      end
    end
    moves
  end
end
