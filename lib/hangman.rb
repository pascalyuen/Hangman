# frozen_string_literal: true

require_relative 'game'
require_relative 'display'
require 'yaml'

# Class for initializing the game
class Hangman
  include Display

  def play
    puts instructions

    # Execute when player loads game
    case Game.input
    when '1'
      Game.new.new_game
    when '2'
      data = ''
      File.open('saves/saved_game', 'r') { |file| data = YAML.load(file) }

      game = Game.new(data[:round_number], data[:guess], data[:secret_word])
      game.load_game
    end
  end
end

Hangman.new.play
