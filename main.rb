# frozen_string_literal: true

require_relative 'lib/game'
require_relative 'lib/clear_screen'

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
  puts '3. Simulate a Game'

  human_or_ai = user_input
  human_or_ai = user_input until human_or_ai.between?(1, 3)
  human_or_ai
end

against_ai = choose_player_or_ai
ClearScreen.clear_screen

player_one = choose_player == 1 if against_ai == 2
ClearScreen.clear_screen
game = Game.new(against_ai, player_one)
game.start
