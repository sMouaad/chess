require_relative '../piece'

class Bishop < Piece
  attr_reader :symbol

  MOVES_OFFSETS = [1, -1].repeated_permutation(2).to_a
  def initialize(color, coordinates)
    super
    @symbol = Piece::PIECES[:bishop].colorize(color)
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
