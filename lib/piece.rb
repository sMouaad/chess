require_relative 'notation'
require_relative 'move_validator'
require_relative 'board'
class Piece
  include Notation
  include MoveValidator

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

  def rank
    coordinates_rank(coordinates)
  end

  def file
    coordinates_file(coordinates)
  end

  def to_s
    self.class.to_s
  end
end
