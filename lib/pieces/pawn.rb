require_relative '../piece'

class Pawn < Piece
  attr_reader :symbol
  attr_accessor :en_passant

  MOVE_OFFSETS_ONE = 1
  MOVE_OFFSETS_TWO = -1
  RANK = %w[2 7].freeze
  def initialize(color, coordinates)
    super
    @symbol = Piece::PIECES[:pawn].colorize(color)
    @en_passant = False
  end

  def next_moves
    moves = []
    row, column = to_index(coordinates)
    offset = (color == Board::PLAYER_ONE ? MOVE_OFFSETS_ONE : MOVE_OFFSETS_TWO)
    final_position = [row, column + offset]
    moves << final_position if correct_index?(final_position) && yield(final_position)
    moves << [row, column + (offset * 2)] if coordinates[1] == RANK[offset] && yield(final_position) # 2 square move

    moves
  end
end
