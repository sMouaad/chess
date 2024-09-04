require_relative 'notation'
require_relative 'board'
class Piece
  include Notation
  attr_reader :coordinates, :color

  PIECES = { knight: '♞', queen: '♛', king: '♚', rook: '♜', bishop: '♝', pawn: '♟' }.freeze
  def initialize(color, coordinates)
    @color = color
    @coordinates = coordinates # coordinates (e.g: h1 d3 f4)
  end

  def enemy?(piece)
    raise ArgumentError unless piece.is_a? Piece

    color != piece.color
  end
end
