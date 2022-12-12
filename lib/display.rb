# frozen_string_literal: true

require_relative 'game'

# Module for all the displayed strings
module Display
  def instructions
    %(
Try to guess the secret word within 8 turns!
To start a new game, enter "1"
To load a save, enter "2"
)
  end

  def new_save_instructions
    'To save a game, enter "3"'
  end

  def enter_guess
    'Guess a letter or the whole word'
  end

  def invalid_input
    'Invalid input. Please try again'
  end

  def correct_guess
    "Congratulations! You guessed it! The secret word is #{@secret_word}"
  end

  def game_over_msg
    "Game Over! The secret word is #{@secret_word}"
  end
end
