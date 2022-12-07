require_relative 'display'
require 'pry-byebug'

class Game
  include Display

  attr_reader :round_number, :user_input, :secret_word
  attr_accessor :guess

  TOTAL_ROUNDS = 8

  def play
    load_file
    puts instructions

    @round_number = 1
    @guess = Array.new(@secret_word.length) { '_' }

    while @round_number <= 8
      break if round
      @round_number += 1
    end
  end

  def round
    # Display underscores and remaining tries
    puts "#{TOTAL_ROUNDS - @round_number + 1} tries remaining"
    puts @guess.join(' ')

    @user_input = get_input

    # Determine if the input is a word or a letter
    @user_input.length == 1 ? check_letter : check_word
    end

  def check_letter
    # Last round
    if @round_number == TOTAL_ROUNDS && @guess.join('') != @secret_word
      puts game_over
    end

    # Correct guess
    if @secret_word.include?(@user_input)
      update_guess(@secret_word, @guess, @user_input)
      if @guess.join('') == @secret_word
        puts correct_guess
        true
      end
    end

    # Incorrect guess, not last round -> Nothing happens
  end

  def check_word
        # Correct guess
        if @user_input == @secret_word
          puts correct_guess
          true
        elsif @round_number == TOTAL_ROUNDS
          puts game_over
        end

        # Incorrect guess, not last round -> Nothing happens
  end

  def get_input
    input = gets.chomp
    until input.length.between?(1, 12) && input.match(/[a-zA-Z]+/)
      puts "#{invalid_input}. #{enter_guess}"
      input = gets.chomp
    end
    input
  end

  def update_guess(secret_word, guess, user_input)
    secret_word.each_char.with_index do |c, idx|
      guess[idx] = c if c == user_input
    end
  end

  def load_file
    dictionary = []
    file = File.open('./../dictionary.txt', 'r')
      while !file.eof?
        word = file.readline.chomp
        dictionary << word
      end

    # Select a word between 5 and 12 characters long from the dictionary
    loop do
      @secret_word = dictionary.sample(1)[0].downcase
      break if @secret_word.length.between?(5, 12)
    end

    puts "The secret word is #{@secret_word}(#{@secret_word.length})"
  end

end
