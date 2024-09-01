require_relative '../piece'
class King < Piece
  attr_reader :symbol

  def initialize(color)
    super
    @symbol = Piece::PIECES[:king].colorize(color)
  end
end
