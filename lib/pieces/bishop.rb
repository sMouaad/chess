require_relative '../piece'

class Bishop < Piece
  attr_reader :symbol, :notation

  MOVES_OFFSETS = [1, -1].repeated_permutation(2).to_a
  def initialize(color, coordinates)
    super
    @symbol = Piece::PIECES[:bishop].colorize(color)
    @notation = 'B'
  end
end
