require_relative '../piece'
class King < Piece
  attr_reader :symbol, :notation
  attr_writer :checked

  MOVES_OFFSETS = [1, -1, 0].repeated_permutation(2).to_a[0..-2] # Removes [0,0]
  MOVES_OFFSETS.pop
  def initialize(color, coordinates)
    super
    @notation = 'K'
    @checked = false
  end

  def checked?
    @checked
  end

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

  def can_castle_long?(board)
    !(checked? || moved? || long_castle_blocked?(board, color))
  end

  def can_castle_short?(board)
    !(checked? || moved? || short_castle_blocked?(board, color))
  end
end
