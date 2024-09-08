require_relative '../piece'

class Bishop < Piece
  attr_reader :symbol, :notation

  MOVES_OFFSETS = [1, -1].repeated_permutation(2).to_a
  def initialize(color, coordinates)
    super
    @notation = 'B'
  end
end
