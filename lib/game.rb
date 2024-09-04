require_relative 'board'
class Game
  def initialize
    @board = Board.new
  end

  def start
    @board.print_board
  end

  def next_moves
    @board.data.compact.each do |piece|
      filter_move(piece)
    end
  end

  def filter_move(piece)
    piece_moves = piece.next_moves do |move|
      row, column = move
      @board.piece_at(row, column).nil?
    end
    piece_moves.reject! do |final_position|
      row, column = final_position
      piece_board = @board.piece_at(row, column)
      piece.enemy?(piece_board) || piece_board.instance_of?(King)
    end
  end
end

Game.new.start
