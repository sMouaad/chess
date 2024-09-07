require_relative 'notation'
require_relative 'move_validator'
require_relative 'board'
class Piece
  include Notation
  include MoveValidator

  attr_reader :color
  attr_accessor :coordinates

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

  def next_moves_algebraic(board)
    moves = filter_checked_moves(board, next_moves(board))
    moves = moves.map do |move|
      simulated_board = simulate_move(board, to_index(coordinates), move)
      move_to_algebraic(board, self, move) + (check?(simulated_board, enemy_color) ? '+' : '')
    end
    [coordinates, moves]
  end

  def enemy_color
    color == Board::PLAYER_ONE ? Board::PLAYER_TWO : Board::PLAYER_ONE
  end

  def to_s
    self.class.to_s
  end

  # Method for Queen, Rook, Bishop to inherit due to them having the same logic, to be overridden in other pieces
  def next_moves(board)
    moves = []
    row, column = to_index(coordinates)
    self.class::MOVES_OFFSETS.each do |move|
      offset_row, offset_column = move
      next_position = [row + offset_row, column + offset_column]
      while correct_index?(next_position) && empty_square?(board, next_position)
        moves << next_position
        offset_row += move.first
        offset_column += move.last
        next_position = [row + offset_row, column + offset_column]
      end
      moves << next_position if correct_index?(next_position) && enemy_square?(board, next_position)
    end
    moves
  end

  private

  def filter_checked_moves(board, moves)
    moves.reject do |move|
      simulated_board = simulate_move(board, to_index(coordinates), move)
      check?(simulated_board, color)
    end
  end
end
