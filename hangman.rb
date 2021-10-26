require_relative 'game'
require 'yaml'
# Game Hangman
class Hangman

  def initialize
    @allowed_guesses = 6
    @game_lost = false
  end

  def select_game
    puts 'Select: 1 - NEW GAME, 2 - LOAD GAME'
    selection = gets.chomp

    if selection == '1'
      @game = Game.new(getting_word)
      play
    elsif selection == '2'
      puts '--- LOADING GAME ---'
      load_game
      puts '--- GAME LOADED ---'
      play
    else
      select_game
    end
  end

  def getting_word
    file = File.open('5desk.txt', 'r')
    appropriate_words = []
    until file.eof?
      line = file.readline
      if line.length > 6 && line.length < 14
        appropriate_words.push(line.chomp)
      end
    end

    appropriate_words.sample.downcase
  end

  def getting_guess
    puts ''
    puts 'Enter your guess (a-z) or (5) to SAVE the game'
    gets.chomp.downcase
  end

  def check_input(guess)
    if guess == '5'
      save_game
      puts '---GAME SAVED---'
    end
    if guess.match(/[a-zA-Z]/) && guess.length == 1
      return guess
    end
    puts 'aaaa'
    '-1'
  end
  
  def check_guess(guess)
    if guess == '-1'
      puts 'Please enter a single letter'
      return
    end
    if @game.guessed_letters.include?(guess)
      puts 'You already tried this letter'
    else
      unless @game.secret_word.include?(guess)
        @game.guess_count += 1
      end
      @game.guessed_letters.push(guess)
    end
  end

  def display_guessed_letters
    puts "Already guessed letters are - #{@game.guessed_letters.join(' ')}"
  end

  def display_hidden_word
    puts "Secret text - #{@game.secret_word}" #delete before finish
    puts ''

    rx = if @game.guessed_letters.length.zero?
           Regexp.new "[#{@game.secret_word}]"
         else
           Regexp.new "[^#{@game.guessed_letters.join()}]"
         end

    puts "The secret word is - #{@game.secret_word.gsub(rx, '_')}"
  end

  def remaining_guess_count
    @allowed_guesses - @game.guess_count
  end

  def display_guess_count
    puts "Remaining guesses - #{remaining_guess_count}"
  end

  def checking_game_won
    sw = @game.secret_word.split('')
    d = sw.difference(@game.guessed_letters)
    if d.length.zero?
      @game.game_won = true
    elsif remaining_guess_count.zero?
      @game_lost = true
    end
  end

  def display_winning_message
    puts ''
    puts 'You are the winner!'
  end

  def display_loser_message
    puts ''
    puts 'You lost :('
  end

  def save_game
    File.open('saved_game.yaml', 'w') do |file|
      file.puts YAML::dump(@game)
    end  
  end

  def load_game
    File.open('saved_game.yaml', 'r') do |file|
      @game = YAML::load(file)
    end

  end

  def play
    until @game.game_won || @game_lost
      puts ''
      puts ''
      display_hidden_word
      display_guessed_letters
      display_guess_count
      check_guess(check_input(getting_guess))
      checking_game_won
    end
    if @game.game_won
      display_winning_message
    else
      display_loser_message
    end
  end
end

h = Hangman.new
h.select_game


