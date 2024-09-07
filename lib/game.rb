require_relative 'board'
require_relative 'notation'
require_relative 'players/human'
require_relative 'players/computer'
class Game
  include Notation

  attr_reader :current_player

  def initialize
    @board = Board.new
    @player = [Human.new, Human.new]
    @current_player = 0
  end

  def start
    loop do
      @board.print_board
      initial_pos, parsed_notation = play
      game_over?(initial_pos)
      if initial_pos == :short_castle
        @board.short_castle(current_player_color)
      elsif initial_pos == :long_castle
        @board.long_castle(current_player_color)
      else
        final_pos = to_index(parsed_notation[:final_position])
        initial_pos = to_index(initial_pos)
        @board.piece_move(initial_pos, final_pos)
        @board.piece_at(*final_pos).en_passant = true if en_passant?(initial_pos, final_pos)
        capture_en_passant(final_pos)
      end
      next_player_turn
    end
  end

  def capture_en_passant(final_pos)
    piece = @board.piece_at(*final_pos)
    return unless piece.is_a? Pawn

    return unless correct_index?(enemy_position = [final_pos.first +
    offset = (current_player_color == Board::PLAYER_ONE ? -1 : 1), final_pos.last])

    enemy_piece = @board.piece_at(*enemy_position)
    @board.data[final_pos.first + offset][final_pos.last] = nil if p enemy_piece.is_a? Pawn
  end

  def en_passant?(initial_pos, final_pos)
    @board.piece_at(*final_pos).is_a?(Pawn) && (final_pos.first - initial_pos.first).abs == 2
  end

  def game_over?(initial_pos)
    return unless initial_pos.nil?

    puts 'Checkmate!'
  end

  def current_player_color
    current_player.zero? ? Board::PLAYER_ONE : Board::PLAYER_TWO
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
    king = @board.king(current_player_color)
    all_moves[:long_castle] = 'O-O-O' if king.can_castle_long?(@board)
    all_moves[:short_castle] = 'O-O' if king.can_castle_short?(@board)
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
    found_value = nil
    moves.each_value { |element| found_value = element if element.include? player_move }
    [moves.key(found_value), parse_notation(player_move)]
  end

  # current_player can only have 0 or 1 as values, 0 : player_one, 1 : player_two
  def next_player_turn
    @current_player = (current_player + 1) % 2
  end
end

test = Game.new
test.start
