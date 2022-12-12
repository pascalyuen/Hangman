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
    @user_input = Game.input
    case @user_input
    when '1'
      Game.new.new_game
    when '2'
      file_name = 'saves/saved_game'
      data = ''
      File.open(file_name, 'r') do |file|
        data = Game.from_yaml(file)
      end

      game = Game.new(data[:round_number], data[:guess], data[:secret_word])
      game.load_game
    end
  end
end

Hangman.new.play
