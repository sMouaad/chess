class Piece
  PIECES = { knight: '♞', queen: '♛', king: '♚', rook: '♜', bishop: '♝', pawn: '♟' }.freeze
  def initialize(color)
    @color = color
  end
end
