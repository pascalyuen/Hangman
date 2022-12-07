require_relative 'display'

class Game
  include Display

  attr_reader :secret_word

  def play
    load_file
    puts instructions

    # Testing with one round
    round_number = 0
    round

    # while round_number < 8
    #   break if round
    #   round_number += 1
    # end
  end

  def round
    # Display underscores
    # secret_word.length.times { print '_ ' }
    user_input = get_input
    
    # A1. Whole word, correct guess
    if user_input == @secret_word
      puts correct_guess
      true
    end

    # A2. Whole word, incorrect guess
    # B1. Last letter and correct guess
    # B2. Not last letter, correct guess
    # B3. Not last letter, incorrect guess
    # C. Last round, incorrect guess (word or letter)
  end

  def get_input
    input = gets.chomp
    until input.length.between?(5, 12)
      puts "#{invalid_input}. #{enter_guess}"
      input = gets.chomp
    end
    input
  end

  def load_file
    dictionary = []
    file = File.open('./../dictionary.txt', 'r')
      while !file.eof?
        word = file.readline.chomp
        dictionary << word
      end
    @secret_word = dictionary.sample(1)[0]
    puts "The secret word is #{@secret_word}"
  end
end
