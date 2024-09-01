require_relative '../piece'

class Rook < Piece
  attr_reader :symbol

  def initialize(color)
    super
    @symbol = Piece::PIECES[:rook].colorize(color)
  end
end
