# frozen_string_literal: true

# Class for loading the dictionary and selecting a random word
class Dictionary
  def load_dictionary
    dictionary = []
    file = File.open('dictionary.txt', 'r')
    until file.eof?
      word = file.readline.chomp
      dictionary << word
    end
    dictionary
  end

  def random_word
    secret_word = ''
    loop do
      secret_word = load_dictionary.sample(1)[0]
      break if secret_word.length.between?(5, 12)
    end
    secret_word
  end
end
