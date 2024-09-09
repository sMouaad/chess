# frozen_string_literal: true

require_relative '../player'

# AI
class Computer
  def play(moves)
    moves.sample
  end
end
