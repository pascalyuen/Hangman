require_relative 'display'

class Game
  include Display

  attr_reader :round_number, :user_input, :secret_word

  TOTAL_ROUNDS = 8

  def play
    load_file
    puts instructions

    @round_number = 0
    # Testing with one round
    round

    # while round_number < 8
    #   break if round
    #   round_number += 1
    # end
  end

  def round
    # Display underscores and remaining tries
    puts "#{TOTAL_ROUNDS - @round_number} tries remaining"
    secret_word.length.times { print '_ ' }
    puts

    @user_input = get_input

    # Determine if the input is a word or a letter
    @user_input.length == 1 ? check_letter : check_word
  
    # C. Last round, incorrect guess (word or letter)
  end

  def check_letter
    # B1. Last letter and correct guess
    # B2. Not last letter, correct guess
    if @secret_word.include?(@user_input)
      @secret_word.each_char do |c|
        if c == @user_input
          print "#{c} "
          else
            print '_ '
          end
      end
      puts
    end

    # B3. Not last letter, incorrect guess -> Nothing happens
  end

  def check_word
        # A1. Whole word, correct guess
        if @user_input == @secret_word
          puts correct_guess
          true
        end
    
        # A2. Whole word, incorrect guess -> Nothing happens
  end

  def get_input
    input = gets.chomp
    until input.length.between?(1, 12) && input.match(/[a-zA-Z]+/)
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

    # Select a word between 5 and 12 characters long
    loop do
      @secret_word = dictionary.sample(1)[0].downcase
      break if @secret_word.length.between?(5, 12)
    end

    puts "The secret word is #{@secret_word}(#{@secret_word.length})"
  end

end
