# Game class for Hangman
class Game
  attr_accessor :game_won, :guessed_letters, :guess_count
  attr_reader :secret_word

  def initialize (secret_word)
    @guess_count = 0
    @guessed_letters = []
    @game_won = false
    @secret_word = secret_word
  end
end
