# frozen_string_literal: true

require 'io/console'

# Module to clear screen
module ClearScreen
  def self.clear_screen
    $stdout.clear_screen
  end
end
