require_relative '../player'
require_relative '../notation'

class Human
  include Notation
  def play(possible_moves)
    print_possible_moves(possible_moves)
    loop do
      user_move = gets.chomp
      return user_move if correct_notation?(user_move)

      puts 'Incorrect algebraic format, try again...'
    end
  end

  private

  def print_possible_moves(possible_moves)
    possible_moves.each do |piece_move|
      print "#{piece_move} "
    end
    puts
  end
end
