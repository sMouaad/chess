# frozen_string_literal: true

require_relative 'move_validator'

# Notation module that contains operations on algebraic notation and indexes
module Notation
  include MoveValidator
  NOTATION = /^(?<piece>(?<_>[KBNQR][a-h]?[1-8]?)|[a-h])?(?:(?<=[a-h])x|x?)(?<final_position>[a-h][1-8])(?<promotion>=?[KBNQR])?(?<check?>[#+])?$/.freeze
  CASTLE_NOTATION = /^O-O(?:-O)?$/.freeze
  COORDINATES = /^[a-h][1-8]$/.freeze
  def to_coordinates(row, column)
    raise ArgumentError unless [row, column].all?(Integer)

    ('a'.ord + column).chr + (row + 1).to_s
  end

  def to_index(coordinates)
    raise ArgumentError unless coordinates.is_a?(String) && correct_coordinates?(coordinates)

    [coordinates[1].to_i - 1, coordinates[0].ord - 'a'.ord]
  end

  def notation_check?(notation)
    raise ArgumentError unless notation.is_a? String

    notation[-1] == '+'
  end

  def correct_index?(index)
    index.all? { |element| element.between?(0, 7) }
  end

  def parse_notation(algebraic)
    raise ArgumentError unless algebraic.is_a? String

    algebraic.match(NOTATION) || algebraic.match(CASTLE_NOTATION)
  end

  def correct_notation?(algebraic)
    raise ArgumentError unless algebraic.is_a? String

    algebraic.match?(NOTATION) || algebraic.match?(CASTLE_NOTATION)
  end

  def coordinates_rank(coordinates)
    raise ArgumentError unless coordinates.is_a?(String) && correct_coordinates?(coordinates)

    coordinates[1]
  end

  def coordinates_file(coordinates)
    raise ArgumentError unless coordinates.is_a?(String) && correct_coordinates?(coordinates)

    coordinates[0]
  end

  def move_to_algebraic(board, piece, move)
    "#{piece.notation}#{print_capture(board, piece, move)}#{to_coordinates(*move)}"
  end

  def correct_coordinates?(coordinates)
    coordinates.match?(COORDINATES)
  end

  private

  def print_capture(board, piece, piece_move)
    return unless piece.is_a?(Pawn) || !board.piece_at(*piece_move).nil?

    if piece.is_a?(Pawn)
      return unless pawn_capture?(board, piece, piece_move)

      "#{piece.file}x"
    else
      'x'
    end
  end

  def capture_en_passant?(board, piece, piece_position)
    offset = (piece.color == Board::PLAYER_ONE ? -1 : 1)
    copy_board = simulate_move(board, to_index(piece.coordinates), piece_position)
    piece_at_pos = copy_board.piece_at(piece_position.first + offset, piece_position.last)
    piece_at_pos.is_a?(Pawn)
  end

  def pawn_capture?(board, piece, piece_position)
    !board.piece_at(*piece_position).nil? || capture_en_passant?(board, piece,
                                                                 piece_position)
  end
end
