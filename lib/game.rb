require_relative 'display'

class Game
  include Display

  def play
    load_file
    puts instructions
    round_number = 0

    # while round_number < 8
    #   break if round
    #   round_number += 1
    # end
  end

  def user_input
    input = gets.chomp
    until input.length.between?(5, 12)
      puts "#{invalid_input}. #{enter_guess}"
      input = gets.chomp
    end
  end

  def round
    # Whole word, correct guess
    if user_input == secret_word
      puts correct_guess
      true
    end
  end

  def load_file
    dictionary = []
    file = File.open('./../dictionary.txt', 'r')
      while !file.eof?
        word = file.readline.chomp
        dictionary << word
      end
    secret_word = dictionary.sample(1)[0]
    puts "The secret word is #{secret_word}"
  end
end
