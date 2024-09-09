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
    if piece.is_a?(Pawn) && piece.promotion?(move)
      %w[N Q B R].map do |promoted_piece|
        simulated_board = deep_copy(board)
        simulated_board.promote_pawn(piece.coordinates, promoted_piece, move)
        "#{piece.notation}#{print_capture(board, piece,
                                          move)}#{to_coordinates(*move)}=#{promoted_piece}#{print_check_or_mate(
                                            simulated_board, piece
                                          )}"
      end
    else
      simulated_board = simulate_move(board, to_index(piece.coordinates), move)
      "#{piece.notation}#{print_capture(board, piece,
                                        move)}#{to_coordinates(*move)}#{print_check_or_mate(simulated_board, piece)}"
    end
  end

  def correct_coordinates?(coordinates)
    coordinates.match?(COORDINATES)
  end

  # Takes as argument the coordinate of a piece and an array of coordinates of other pieces

  def ambiguity_file?(piece, other_pieces)
    other_pieces.any? do |second_piece|
      piece != second_piece && (coordinates_file(piece) == coordinates_file(second_piece))
    end
  end

  def ambiguity_rank?(piece, other_pieces)
    other_pieces.any? do |second_piece|
      piece != second_piece && (coordinates_rank(piece) == coordinates_rank(second_piece))
    end
  end

  ###

  private

  def print_check_or_mate(board, piece)
    if checkmate?(board, enemy_color(piece.color))
      '#'
    elsif check?(board, enemy_color(piece.color))
      '+'
    else
      ''
    end
  end

  def print_capture(board, piece, piece_move)
    return unless piece.is_a?(Pawn) || !board.piece_at(*piece_move).nil?

    if piece.is_a?(Pawn)
      return unless pawn_capture?(board, piece, piece_move)

      "#{piece.file}x"
    else
      'x'
    end
  end
end
