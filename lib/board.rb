require 'colorize'
require_relative 'pieces/pawn'
require_relative 'pieces/rook'
require_relative 'pieces/king'
require_relative 'pieces/knight'
require_relative 'pieces/queen'
require_relative 'pieces/bishop'

# Board class handling mostly printing logic
class Board
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

  def initialize_player(player)
    row = player == PLAYER_ONE ? 0 : -1
    pawn_row = player == PLAYER_ONE ? 1 : -2

    pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

    @data[row] = pieces.map { |piece| piece.new(player) }
    @data[pawn_row] = Array.new(8) { Pawn.new(player) }
  end

  def print_board
    @data.reverse.each_with_index do |rank, index|
      print "#{8 - index} "
      rank.each_with_index do |cell, subindex|
        new_cell = "#{cell&.symbol || EMPTY_CELL} "

        print((index + subindex).even? ? new_cell.colorize(background: LIGHT_CELL) : new_cell.colorize(background: DARK_CELL))
      end
      puts
    end
    puts '  a b c d e f g h'
  end
end

Board.new.print_board
