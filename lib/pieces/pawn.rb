require_relative '../piece'

class Pawn < Piece
  attr_reader :symbol, :notation
  attr_accessor :en_passant

  MOVE_OFFSETS_ONE = 1
  MOVE_OFFSETS_TWO = -1
  RANK = [nil, '2', '7'].freeze
  def initialize(color, coordinates)
    super
    @symbol = Piece::PIECES[:pawn].colorize(color)
    @notation = ''
    @en_passant = false
  end

  def next_moves
    moves = []
    row, column = to_index(coordinates)
    offset = (color == Board::PLAYER_ONE ? MOVE_OFFSETS_ONE : MOVE_OFFSETS_TWO)
    final_position = [row + offset, column]
    moves << final_position if correct_index?(final_position) && yield(final_position)
    moves << [row + (offset * 2), column] if rank == RANK[offset] && yield(final_position)

    moves
  end

  def capture_moves
    moves = []
    row, column = to_index(coordinates)
    offset = (color == Board::PLAYER_ONE ? MOVE_OFFSETS_ONE : MOVE_OFFSETS_TWO)
    [column + offset, column - offset].each do |column_offset|
      final_position = [row + offset, column_offset]
      moves << final_position if correct_index?(final_position) && yield(final_position)
    end
    moves
  end
end
