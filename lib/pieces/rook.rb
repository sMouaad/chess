require_relative '../piece'

class Rook < Piece
  attr_reader :symbol, :notation

  MOVES_OFFSETS = [[0, 1], [0, -1], [1, 0], [-1, 0]].freeze
  def initialize(color, position)
    super
    @symbol = Piece::PIECES[:rook].colorize(color)
    @notation = 'R'
  end
end
