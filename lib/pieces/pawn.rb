require_relative '../piece'

class Pawn < Piece
  attr_reader :symbol

  def initialize(color)
    super
    @symbol = Piece::PIECES[:pawn].colorize(color)
  end
end
