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
      return if game_over?(initial_pos)

      if initial_pos == :short_castle
        @board.short_castle(current_player_color)
      elsif initial_pos == :long_castle
        @board.long_castle(current_player_color)
      else
        final_pos = to_index(parsed_notation[:final_position])
        initial_pos = to_index(initial_pos)
        @board.piece_move(initial_pos, final_pos)
        @board.king(enemy_color(current_player_color)).checked = !parsed_notation[:check?].nil?
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

    @board.data[final_pos.first + offset][final_pos.last] = nil if @board.piece_at(*enemy_position).is_a? Pawn
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

  # Structure of the hash is {initial_position_of_the_piece => all_the_moves possible for that piece in an array}
  def remove_ambiguity(hash)
    all_moves(hash).each do |move|
      conflicted_pieces = conflicts(hash, move)
      disambiguate_pieces(hash, conflicted_pieces, move) unless conflicted_pieces.length == 1
    end
  end

  # for a given move give all the pieces that are in conflict
  def conflicts(hash, piece_move)
    conflicted_pieces = []
    hash.each do |piece_position, piece_moves|
      piece_moves.each do |move|
        conflicted_pieces << piece_position if piece_move == move
      end
    end
    conflicted_pieces
  end

  def disambiguate_pieces(hash, pieces, move)
    pieces.each do |piece|
      str = move[0] + if ambiguity_file?(piece, pieces) && ambiguity_rank?(piece, pieces)
                        piece
                      elsif !ambiguity_file?(piece, pieces)
                        coordinates_file(piece)
                      else
                        coordinates_rank(piece)
                      end
      hash[piece].push("#{str}#{move[1..]}").delete(move)
    end
  end

  def ambiguity_file?(piece, other_pieces)
    other_pieces.any? do |second_piece|
      piece != second_piece && (coordinates_file(piece) == coordinates_file(second_piece))
    end
  end

  def ambiguity_rank?(piece, other_pieces)
    other_pieces.any? do |second_piece|
      piece != second_piece && (coordinates_rank(piece) == coordinates_rank(second_piece))
    end
  end

  def all_moves(hash)
    hash.values.flatten.uniq
  end
end

test = Game.new
test.start
