require_relative 'board'
require_relative 'notation'
require_relative 'move_validator'
require_relative 'players/human'
require_relative 'players/computer'

# Game class controlling the flow of the game
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
      initial_pos, move_notation = play
      return if game_over?(initial_pos)

      make_move(initial_pos, move_notation)
      next_player_turn
    end
  end

  def make_move(initial_pos, move)
    if initial_pos == :short_castle
      @board.short_castle(current_player_color)
    elsif initial_pos == :long_castle
      @board.long_castle(current_player_color)
    else
      final_pos = move[:final_position]
      promotion = move[:promotion]
      if promotion.nil?
        @board.piece_move(to_index(initial_pos), to_index(final_pos))
      else
        # to trim = out of the promotion we do [1]
        @board.promote_pawn(initial_pos, promotion[1], to_index(final_pos))
      end
      @board.king(enemy_color(current_player_color)).checked = !move[:check?].nil?
      capture_en_passant(to_index(final_pos)) # Captures the enemy pawn from board if there is en passant
    end
  end

  # Captures the enemy pawn en passant (if there is an en passant move)

  def capture_en_passant(final_pos)
    piece = @board.piece_at(*final_pos)
    return unless piece.is_a? Pawn

    return unless correct_index?(enemy_position = [final_pos.first +
    offset = (current_player_color == Board::PLAYER_ONE ? -1 : 1), final_pos.last])

    @board.square_remove(final_pos.first + offset, final_pos.last) if @board.piece_at(*enemy_position).is_a? Pawn
  end

  def game_over?(moves)
    # If there are no moves available then gameover
    return false unless moves.nil?

    winner = enemy_color(current_player_color)
    if @board.king(current_player_color).checked?
      puts "Checkmate! #{winner.to_s.capitalize} wins!"
    else
      puts 'Stalemate!'
    end
    true
  end

  def current_player_color
    current_player.zero? ? Board::PLAYER_ONE : Board::PLAYER_TWO
  end

  # returns hash with key as initial position and value as all possible moves
  def next_moves
    all_moves = {}
    @board.each_piece do |piece|
      next unless piece.color == current_player_color # To get moves of the current player

      initial_coordinate, moves = piece.next_moves_algebraic(@board)
      all_moves[initial_coordinate] = moves unless moves.empty?
    end
    remove_ambiguity(all_moves)
    add_castle_moves(all_moves)
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
      player_move = player.play(possible_moves)
    end
    found_value = nil
    moves.each_value { |element| found_value = element if element.include? player_move }
    [moves.key(found_value), parse_notation(player_move)]
  end

  private

  # current_player can only have 0 or 1 as values, 0 : player_one, 1 : player_two
  def next_player_turn
    @current_player = (current_player + 1) % 2
  end

  def add_castle_moves(moves)
    king = @board.king(current_player_color)
    moves[:long_castle] = 'O-O-O' if king.can_castle_long?(@board)
    moves[:short_castle] = 'O-O' if king.can_castle_short?(@board)
  end

  def all_moves(hash)
    hash.values.flatten.uniq
  end
end

test = Game.new
test.start
