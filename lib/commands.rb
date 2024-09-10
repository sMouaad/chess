# frozen_string_literal: true

# Module containing all commands
module Commands
  COMMANDS = %i[flip quit help].freeze

  def commands
    COMMANDS.map(&:to_s)
  end

  def print_commands
    puts "Try these commands : #{commands.join(' ')}\n"
  end

  def command?(cmd)
    COMMANDS.include?(cmd)
  end
end
