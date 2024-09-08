require 'colorize'

require_relative 'pieces/pawn'
require_relative 'pieces/rook'
require_relative 'pieces/king'
require_relative 'pieces/knight'
require_relative 'pieces/queen'
require_relative 'pieces/bishop'

require_relative 'notation'

# Board class handling printing logic, moving, finding... pieces, castling etc..
class Board
  include Notation
  attr_accessor :data

  PLAYER_ONE = :white
  PLAYER_TWO = :black
  DARK_CELL = :black
  LIGHT_CELL = :white
  EMPTY_CELL = ' '.freeze
  def initialize
    @data = Array.new(8) { Array.new(8) }
    initialize_player(PLAYER_ONE)
    initialize_player(PLAYER_TWO)
    # 4,1 2,2 3,5
    @data[5][1] = Queen.new(PLAYER_ONE, to_coordinates(5, 1))
    @data[3][1] = Queen.new(PLAYER_ONE, to_coordinates(3, 1))
    @data[3][3] = Queen.new(PLAYER_ONE, to_coordinates(3, 3))
  end

  def print_board
    data.reverse.each_with_index do |rank, index|
      print "#{8 - index} "
      rank.each_with_index do |cell, subindex|
        new_cell = "#{cell&.symbol || EMPTY_CELL} "

        print((index + subindex).even? ? new_cell.colorize(background: LIGHT_CELL) : new_cell.colorize(background: DARK_CELL))
      end
      puts
    end
    puts '  a b c d e f g h'
  end

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
    initial_row, initial_column = initial_pos
    final_row, final_column = final_pos
    piece_at(*initial_pos).moved = true
    data[final_row][final_column] = data[initial_row][initial_column]
    data[initial_row][initial_column] = nil
    piece_final = piece_at(*final_pos)
    piece_final.en_passant = true if en_passant?(initial_pos, final_pos)
    piece_final.coordinates = to_coordinates(*final_pos)
    each_piece do |piece|
      # pawn can no longer be passed on if a move is played
      piece.en_passant = false if piece.is_a? Pawn
    end
  end

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

  def en_passant?(initial_pos, final_pos)
    piece_at(*final_pos).is_a?(Pawn) && (final_pos.first - initial_pos.first).abs == 2
  end
end
