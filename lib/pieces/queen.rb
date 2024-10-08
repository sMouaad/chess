require_relative '../piece'
require_relative 'bishop'
require_relative 'rook'
class Queen < Piece
  attr_reader :symbol, :notation

  MOVES_OFFSETS = Bishop::MOVES_OFFSETS + Rook::MOVES_OFFSETS
  def initialize(color, coordinates)
    super
    @notation = 'Q'
  end
end
