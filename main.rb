# frozen_string_literal: true

require_relative 'lib/game'
def user_input
  gets.chomp.to_i
end

def choose_player
  puts 'Play as :'
  puts '1. White'
  puts '2. Black'

  one_or_two = user_input
  one_or_two = user_input until one_or_two.between?(1, 2)
  one_or_two
end

def choose_player_or_ai
  puts '1. Human vs Human '
  puts '2. Human vs Computer'

  human_or_ai = user_input
  human_or_ai = user_input until human_or_ai.between?(1, 2)
  human_or_ai
end

against_ai = choose_player_or_ai == 2

player_one = choose_player == 1 if against_ai
game = Game.new(against_ai, player_one)
game.start
