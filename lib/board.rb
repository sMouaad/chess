require 'colorize'

require_relative 'pieces/pawn'
require_relative 'pieces/rook'
require_relative 'pieces/king'
require_relative 'pieces/knight'
require_relative 'pieces/queen'
require_relative 'pieces/bishop'

require_relative 'notation'

FILES = 'a b c d e f g h'.freeze
# Board class handling printing logic, moving, finding... pieces, castling etc..
class Board
  include Notation
  attr_accessor :data

  # They should not be equal to each other
  PLAYER_ONE = :white
  PLAYER_TWO = :black

  DARK_CELL = :light_blue
  LIGHT_CELL = :light_cyan
  EMPTY_CELL = ' '.freeze

  def initialize
    @data = Array.new(8) { Array.new(8) }
    initialize_player(PLAYER_ONE)
    initialize_player(PLAYER_TWO)
  end

  def print_board(flip = false)
    board = flip ? data : data.reverse
    board.each_with_index do |rank, index|
      flip ? print("#{index + 1} ") : print("#{8 - index} ")
      rank = rank.reverse if flip
      rank.each_with_index do |cell, subindex|
        new_cell = "#{cell&.symbol || EMPTY_CELL} "

        print((index + subindex).even? ? new_cell.colorize(background: LIGHT_CELL) : new_cell.colorize(background: DARK_CELL))
      end
      puts
    end
    flip ? puts("  #{FILES.reverse}") : puts("  #{FILES}")
  end

  # Returns king of a given player

  def king(color)
    each_piece(color) do |piece|
      return piece if piece.is_a?(King)
    end
  end

  def long_castle(color)
    rank = color == PLAYER_ONE ? 0 : 7
    king_move = [[rank, 4], [rank, 2]]
    rook_move = [[rank, 0], [rank, 3]]
    piece_move(*king_move)
    piece_move(*rook_move)
  end

  def short_castle(color)
    rank = color == PLAYER_ONE ? 0 : 7
    king_move = [[rank, 4], [rank, 6]]
    rook_move = [[rank, 7], [rank, 5]]
    piece_move(*king_move)
    piece_move(*rook_move)
  end

  def piece_move(initial_pos, final_pos)
    each_piece do |piece|
      # pawn can no longer be passed on if a move is played
      piece.en_passant = false if piece.is_a? Pawn
    end
    initial_row, initial_column = initial_pos
    final_row, final_column = final_pos
    piece_at(*initial_pos).moved = true
    data[final_row][final_column] = data[initial_row][initial_column]
    square_remove(initial_row, initial_column)
    piece_final = piece_at(*final_pos)
    piece_final.en_passant = true if en_passant?(initial_pos, final_pos)
    piece_final.coordinates = to_coordinates(*final_pos)
  end

  # Returns a piece at the given position

  def piece_at(position, position_opt = nil)
    if position_opt.nil?
      row, column = to_index(position)
    elsif [position, position_opt].all?(Integer) && [position, position_opt].all? { |pos| pos.between?(0, 7) }
      row = position
      column = position_opt
    else
      raise ArgumentError
    end
    data[row][column]
  end

  # Remove a piece in the given position if there is any

  def square_remove(position, position_opt = nil)
    if position_opt.nil?
      row, column = to_index(position)
    elsif [position, position_opt].all?(Integer) && [position, position_opt].all? { |pos| pos.between?(0, 7) }
      row = position
      column = position_opt
    else
      raise ArgumentError
    end
    data[row][column] = nil
  end

  def promote_pawn(piece, promoted_piece_notation, move)
    promoted_piece = Pawn::PROMOTIONS[promoted_piece_notation]
    piece = piece_at(piece)
    square_remove(piece.coordinates)
    data[move.first][move.last] = promoted_piece.new(piece.color, to_coordinates(*move))
  end

  # Iterate through each piece of a given player, if no player given, it will iterate through all players

  def each_piece(color = nil, &block)
    if color.nil?
      data.flatten.compact.each(&block)
    else
      pieces = data.flatten.compact.select { |piece| piece.color == color }
      pieces.each(&block)
    end
  end

  def enemy_color(color)
    color == Board::PLAYER_ONE ? Board::PLAYER_TWO : Board::PLAYER_ONE
  end

  private

  def initialize_player(player)
    row = player == PLAYER_ONE ? 0 : 7
    pawn_row = player == PLAYER_ONE ? 1 : 6

    pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

    data[row] = pieces.map.with_index { |piece, column| piece.new(player, to_coordinates(row, column)) }
    data[pawn_row] = Array.new(8) { |column| Pawn.new(player, to_coordinates(pawn_row, column)) }
  end

  # Checks if the enemy piece at a given position allows an en passant in case it's a pawn

  def en_passant?(initial_pos, final_pos)
    piece_at(*final_pos).is_a?(Pawn) && (final_pos.first - initial_pos.first).abs == 2
  end
end
