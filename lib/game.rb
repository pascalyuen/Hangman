# frozen_string_literal: true

require_relative 'display'
require 'yaml'

# Class for the game
class Game
  include Display

  attr_reader :round_number, :dictionary, :user_input, :secret_word
  attr_accessor :guess

  TOTAL_ROUNDS = 8

  def initialize(round_number = 1, guess = [], secret_word = 'testing')
    @round_number = round_number
    @guess = guess
    @secret_word = secret_word
  end

  def new_game
    load_dictionary
    @secret_word = random_word
    @guess = Array.new(@secret_word.length) { '_' }

    all_rounds
  end

  def load_game
    unless File.exist?('saves/saved_game')
      puts 'File does not exist'
      return
    end
    puts '*** Save loaded ***'
    all_rounds
  end

  def all_rounds
    while @round_number <= 8
      break if round

      @round_number += 1
    end
  end

  def round
    # Display underscores and remaining tries
    # puts "The secret word is #{@secret_word}(#{@secret_word.length})"
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

  def load_dictionary
    @dictionary = []
    file = File.open('dictionary.txt', 'r')
    until file.eof?
      word = file.readline.chomp
      @dictionary << word
    end
  end

  def random_word
    loop do
      @secret_word = @dictionary.sample(1)[0]
      break if @secret_word.length.between?(5, 12)
    end
    @secret_word
  end

  def new_save
    Dir.mkdir('saves') unless Dir.exist?('saves')
    file_name = 'saves/saved_game'
    File.open(file_name, 'w') do |file|
      file << to_yaml
    end

    puts '*** Saved ***'
  end

  def to_yaml
    YAML.dump({
                round_number: @round_number,
                guess: @guess,
                secret_word: @secret_word
              })
  end

  def self.from_yaml(string)
    YAML.load(string)
  end
end
