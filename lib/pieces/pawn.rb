require_relative '../piece'

class Pawn < Piece
  attr_reader :symbol, :notation
  attr_writer :en_passant

  MOVE_OFFSETS_ONE = 1
  MOVE_OFFSETS_TWO = -1
  RANK = [nil, '2', '7'].freeze
  def initialize(color, coordinates)
    super
    @notation = ''
    @en_passant = false
  end

  def en_passant?
    @en_passant
  end

  def calculate_next_moves(board)
    moves = []
    row, column = to_index(coordinates)
    offset = (color == Board::PLAYER_ONE ? MOVE_OFFSETS_ONE : MOVE_OFFSETS_TWO)
    final_position = [row + offset, column]
    moves << final_position if correct_index?(final_position) && empty_square?(board, final_position)
    final_position = [row + (offset * 2), column]
    moves << final_position if rank == RANK[offset] && empty_square?(board, final_position)
    moves + capture_moves(board)
  end

  def capture_moves(board)
    moves = []
    row, column = to_index(coordinates)
    offset = (color == Board::PLAYER_ONE ? MOVE_OFFSETS_ONE : MOVE_OFFSETS_TWO)
    [offset, -offset].each do |column_offset|
      final_column_offset = column + column_offset
      final_position = [row + offset, final_column_offset]
      moves << final_position if correct_index?(final_position) && (enemy_square?(board,
                                                                                  final_position) || move_en_passant?(board,
                                                                                                                      [row,
                                                                                                                       final_column_offset]))
    end
    moves
  end

  private

  def move_en_passant?(board, position)
    enemy_piece = board.piece_at(*position)
    enemy_piece.is_a?(Pawn) && enemy?(enemy_piece)
  end
end
