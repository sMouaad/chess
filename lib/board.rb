require 'colorize'

require_relative 'pieces/pawn'
require_relative 'pieces/rook'
require_relative 'pieces/king'
require_relative 'pieces/knight'
require_relative 'pieces/queen'
require_relative 'pieces/bishop'

require_relative 'notation'

# Board class handling mostly printing logic
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

  private

  def initialize_player(player)
    row = player == PLAYER_ONE ? 0 : 7
    pawn_row = player == PLAYER_ONE ? 1 : 6

    pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

    data[row] = pieces.map.with_index { |piece, column| piece.new(player, to_coordinates(row, column)) }
    data[pawn_row] = Array.new(8) { |column| Pawn.new(player, to_coordinates(pawn_row, column)) }
  end
end
