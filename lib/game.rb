require_relative 'board'
require_relative 'notation'
class Game
  include Notation
  def initialize
    @board = Board.new
  end

  def start
    @board.print_board
  end

  def next_moves
    moves = []
    @board.data.compact.each do |file|
      file.compact.each do |piece|
        piece_moves = filter_moves(piece)
        piece_moves_algebraic = piece_moves.map do |piece_move|
          "#{piece.notation}#{print_capture(piece, piece_move)}#{to_coordinates(*piece_move)}"
        end
        moves << [piece, piece_moves, piece_moves_algebraic]
      end
    end
    moves
  end

  def print_capture(piece, piece_move)
    return if @board.piece_at(*piece_move).nil?

    "#{piece.rank if piece.is_a?(Pawn)}x"
  end

  def print_next_moves
    puts 'Possible moves :'
    next_moves.each do |_piece, _piece_moves, piece_moves_algebraic|
      piece_moves_algebraic.each do |move|
        print "#{move} "
      end
    end
    puts
  end

  def test_board
    8.times do |x|
      8.times do |y|
        p @board.piece_at(x, y)
        puts "#{@board.data[x][y]} #{x} #{y} #{to_coordinates(x, y)}"
      end
    end
  end

  private

  def filter_moves(piece)
    if [Queen, Rook, Bishop].include?(piece.class)
      filter_queen_bishop_rook(piece)
    elsif [King, Knight].include?(piece.class)
      filter_king_knight(piece)
    else
      filter_pawn(piece) + piece.capture_moves do |move|
        piece_board = @board.piece_at(*move)
        !piece_board.nil? && piece.enemy?(piece_board)
      end
    end
  end

  def filter_king_knight(piece)
    piece.next_moves do |move|
      piece_board = @board.piece_at(*move) unless move.nil?
      piece_board.nil? || piece.enemy?(piece_board)
    end
  end

  def filter_pawn(piece)
    piece.next_moves do |move|
      piece_board = @board.piece_at(*move) unless move.nil?
      piece_board.nil?
    end
  end

  def filter_queen_bishop_rook(piece)
    piece.next_moves do |move, opt|
      piece_board = @board.piece_at(*move) unless move.nil?
      if opt
        piece.enemy?(piece_board)
      else
        piece_board.nil?
      end
    end
  end
end

test = Game.new
test.start
test.print_next_moves
