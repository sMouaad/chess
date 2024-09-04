require_relative '../piece'
require_relative 'bishop'
require_relative 'rook'
class Queen < Piece
  attr_reader :symbol

  MOVES_OFFSETS = Bishop::MOVES_OFFSETS + Rook::MOVES_OFFSETS
  def initialize(color, coordinates)
    super
    @symbol = Piece::PIECES[:queen].colorize(color)
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
