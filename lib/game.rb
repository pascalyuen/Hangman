# frozen_string_literal: true

require_relative 'display'
require_relative 'dictionary'
require 'yaml'

# Class for the game
class Game
  include Display

  attr_reader :round_number, :dictionary, :user_input, :secret_word, :game_over
  attr_accessor :guess

  TOTAL_ROUNDS = 8

  def initialize(round_number = 1, guess = [], secret_word = 'testing')
    @round_number = round_number
    @guess = guess
    @secret_word = secret_word
  end

  def new_game
    @secret_word = Dictionary.new.random_word
    @guess = Array.new(@secret_word.length) { '_' }
    @game_over = false

    all_rounds
  end

  def load_game
    unless File.exist?('saves/saved_game')
      puts 'File does not exist'
      return
    end
    @game_over = false
    puts '*** Save loaded ***'
    all_rounds
  end

  def all_rounds
    while @round_number <= 8
      round
      break if game_over
    end
  end

  def round
    # Display underscores and remaining tries
    puts "The secret word is #{@secret_word}(#{@secret_word.length})"
    puts "#{TOTAL_ROUNDS - @round_number + 1} tries remaining"
    puts @guess.join(' ')
    puts new_save_instructions

    @user_input = Game.input

    # Execute if player saves game
    new_save if @user_input == '3'

    # Determine if the input is a word or a letter
    @user_input.length == 1 ? check_letter : check_word
  end

  def check_letter
    update_guess(@secret_word, @guess, @user_input)

    # Correct guess of the whole word
    if @guess.join('') == @secret_word
      puts correct_guess
      @game_over = true
    # Last round and wrong guess -> game over
    elsif round_number == TOTAL_ROUNDS
      puts game_over_msg
      @game_over = true
    # Add one to round number if a new letter is not discovered
    elsif !@secret_word.include?(@user_input)
      @round_number += 1
    end
  end

  def check_word
    # Correct guess
    if @user_input == @secret_word
      puts correct_guess
      @game_over = true
    # Not last round and wrong guess -> add round number
    elsif @round_number < TOTAL_ROUNDS
      @round_number += 1
    # Last round and wrong guess -> game over
    else
      puts game_over_msg
      @game_over = true
    end
  end

  def self.input
    input = gets.chomp.downcase
    until input.match(/[a-z]{1,12}/) || input.match(/[1-3]{1}/)
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

  def new_save
    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open('saves/saved_game', 'w') { |file| file << to_yaml }
    puts '*** Saved ***'
  end

  def to_yaml
    YAML.dump({
                round_number: @round_number,
                guess: @guess,
                secret_word: @secret_word
              })
  end
end
