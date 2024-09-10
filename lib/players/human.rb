# frozen_string_literal: true

require_relative '../player'
require_relative '../notation'
require_relative '../commands'

# Human class
class Human
  include Commands
  include Notation
  def play(possible_moves)
    print_possible_moves(possible_moves)
    loop do
      user_choice = gets.chomp
      return user_choice if possible_moves.include?(user_choice) || commands.include?(user_choice)

      if correct_notation?(user_choice)
        puts 'Illegal move, try again...'
      else
        puts 'Incorrect algebraic format, try again...'
      end
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
