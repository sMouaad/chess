require_relative '../piece'

class Queen < Piece
  attr_reader :symbol

  def initialize(color)
    super
    @symbol = Piece::PIECES[:queen].colorize(color)
  end
end
