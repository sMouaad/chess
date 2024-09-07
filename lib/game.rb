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
      initial_pos, parsed_notation = play # Now, the current player is the next player
      if initial_pos.nil?
        puts 'Checkmate!'
        return
      end
      final_pos = to_index(parsed_notation[:final_position])
      @board.king(current_player_color).can_castle = false if @board.piece_at(*initial_pos).is_a? King
      @board.piece_move(initial_pos, final_pos)
    end
  end

  def current_player_color
    (current_player.zero? ? Board::PLAYER_ONE : Board::PLAYER_TWO)
  end

  # returns hash with key as initial position and value as all possible moves
  def next_moves
    all_moves = {}
    @board.data.compact.each do |file|
      file.compact.each do |piece|
        next unless piece.color == current_player_color # To get moves of the current player

        initial_coordinate, moves = piece.next_moves_algebraic(@board)
        all_moves[initial_coordinate] = moves unless moves.empty?
      end
    end
    all_moves
  end

  def play
    moves = next_moves
    return nil if moves.empty?

    possible_moves = moves.values.flatten
    player = @player[current_player]
    player_move = player.play(possible_moves)
    loop do
      break if possible_moves.include? player_move

      puts 'Illegal move, try again...'
      player_move = player.play(moves)
    end
    next_player_turn
    found_value = nil
    moves.each_value { |element| found_value = element if element.include? player_move }
    [to_index(moves.key(found_value)), parse_notation(player_move)]
  end

  # current_player can only have 0 or 1 as values, 0 : player_one, 1 : player_two
  def next_player_turn
    @current_player = (current_player + 1) % 2
  end
end

test = Game.new
test.start
