require_relative 'board'
require_relative 'notation'
require_relative 'players/human'
require_relative 'players/computer'
class Game
  include Notation

  attr_reader :current_player

  def initialize
    @board = Board.new
    @player = [Human.new, Computer.new]
    @current_player = 0
  end

  def start
    loop do
      @board.print_board
      play
    end
  end

  def current_player_color
    (current_player.zero? ? Board::PLAYER_ONE : Board::PLAYER_TWO)
  end

  def next_moves
    moves = []
    @board.data.compact.each do |file|
      file.compact.each do |piece|
        next unless piece.color == current_player_color

        piece_moves = piece.next_moves(@board)
        piece_moves_algebraic = piece_moves.map do |piece_move|
          "#{piece.notation}#{print_capture(piece, piece_move)}#{to_coordinates(*piece_move)}"
        end
        moves << [piece_moves_algebraic]
      end
    end
    p moves.flatten
  end

  def play
    possible_moves = next_moves
    player = @player[current_player]
    player_move = player.play(possible_moves)
    loop do
      p "#{possible_moves} #{player_move}"
      return player_move if possible_moves.include? player_move

      puts 'Illegal move, try again...'
      player_move = player.play(possible_moves)
    end
    next_player_turn
    player_move
  end

  # current_player can only have 0 or 1 as values, 0 : player_one, 1 : player_two
  def next_player_turn
    @current_player = (current_player + 1) % 2
  end

  def print_capture(piece, piece_move)
    return if @board.piece_at(*piece_move).nil?

    "#{piece.rank if piece.is_a?(Pawn)}x"
  end
end

test = Game.new
test.start
