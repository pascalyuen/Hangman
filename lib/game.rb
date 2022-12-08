# frozen_string_literal: true

require_relative 'display'
require 'yaml'

# Main class for the game
class Game
  include Display

  attr_reader :round_number, :dictionary, :user_input, :secret_word
  attr_accessor :guess

  TOTAL_ROUNDS = 8

  def play
    load_file
    puts instructions

    # Execute if player loads game
    @user_input = input
    case @user_input
    when '1'
      new_game
    when '2'
      load_game
    end
  end

  def new_game
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
    puts new_save_instructions

    @user_input = input

    # Execute if player saves game
    new_save if @user_input == '3'

    # Determine if the input is a word or a letter
    @user_input.length == 1 ? check_letter : check_word
  end

  def check_letter
    update_guess(@secret_word, @guess, @user_input)

    # Last round and wrong guess -> game over
    puts game_over if @round_number == TOTAL_ROUNDS && @guess.join('') != @secret_word

    # Correct guess of the whole word
    return unless @guess.join('') == @secret_word

    puts correct_guess
    true
  end

  def check_word
    # Correct guess
    if @user_input == @secret_word
      puts correct_guess
      true
    # Last round and wrong guess -> game over
    elsif @round_number == TOTAL_ROUNDS
      puts game_over
    end
  end

  def input
    input = gets.chomp
    until input.match(/[a-zA-Z]{1,12}/) || input.match(/[1-3]{1}/)
      puts "#{invalid_input}. #{enter_guess}"
      input = gets.chomp
    end
    input
  end

  def update_guess(secret_word, guess, input)
    secret_word.each_char.with_index do |c, idx|
      guess[idx] = c if c == input
    end
  end

  def load_file
    @dictionary = []
    file = File.open('dictionary.txt', 'r')
    until file.eof?
      word = file.readline.chomp
      @dictionary << word
    end

    # Select a word between 5 and 12 characters long from the dictionary
    random_word

    puts "The secret word is #{@secret_word}(#{@secret_word.length})"
  end

  def random_word
    loop do
      @secret_word = @dictionary.sample(1)[0].downcase
      break if @secret_word.length.between?(5, 12)
    end
  end

  def to_yaml
    YAML.dump({
                round_number: @round_number,
                guess: @guess,
                secret_word: @secret_word
              })
  end

  def new_save
    Dir.mkdir('saves') unless Dir.exist?('saves')
    file_name = 'saves/saved_game'
    File.open(file_name, 'w') do |file|
      file << to_yaml
    end
  end

  def load_game
    puts 'Game loaded'
  end
end
