require_relative '../piece'

class Bishop < Piece
  attr_reader :symbol

  def initialize(color)
    super
    @symbol = Piece::PIECES[:bishop].colorize(color)
  end
end
