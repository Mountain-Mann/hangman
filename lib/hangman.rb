require 'yaml'

class Game

  #guesses = []
  #word = ''
  #incorrect_guesses = 10

  def initialize
    puts 'Welcome'
    @guesses = []
    @correct_array = []
    @word = []
    @incorrect_guesses = 10
    ask
  end

  def ask
    puts 'Do you have a game to load? You can do so now by typing: LOAD. If not just press ENTER.'
    load_it = gets.chomp
    load_it
    if load_it == 'LOAD'
      load_game
    end
    puts 'Shall we play Hangman? y/n?'
    answer = gets.chomp
    answer
    if answer == 'y'
      play_game
    elsif answer == 'n'
      stop_game
    else
      puts 'Please type y or n'
      ask
    end
  end

  def play_game
    # start game and print secret word
    puts 'GAME STARTED'
    puts 'Note: you can save the game anytime by typing: SAVE'
    puts "If you/'d like to start over type: START OVER"
    puts ''
    puts "You have #{@incorrect_guesses} incorrect guesses left."
    puts ''
    puts "Sercret word is: #{word_to_secret}"
    puts 'Take guesses by typing in one letter at a time.'
    puts 'What is your guess?'
    guessed_letter = gets.chomp
    letter_guess(guessed_letter)
  end

  def game_iteration
    # correct guess logic
    puts "Letters guessed already: #{@guesses.join(' ')}"
    puts ''
    puts 'What is your guess?'
    guessed_letter = gets.chomp
    letter_guess(guessed_letter)
  end

  def double_guess_game_iteration
    # if player guesses the same letter twice

  end


  def wrong_guess_game_iteration
    # wrong guess logic
    if @incorrect_guesses == 0
      puts 'GAME OVER! You stink...'
    else
      puts "You have #{guesses_left_counter} incorrect guesses left."
      puts "Letters guessed already: #{@guesses.join(' ')}"
      puts "#{rand_word}"
      puts ''
      puts 'What is your guess?'
      guessed_letter = gets.chomp
      letter_guess(guessed_letter)
    end
  end

  def stop_game
    puts 'GAME STOPPED'
  end

  def rand_word
    # pull random word from google list
    list = File.read('google-10000-english-no-swears.txt').split
    @word << list.sample
    word_to_array
  end

  def word_to_array
    # changes rand_word to array
    puts @word
  end

  def word_to_secret
    # turn random word array into dashes
    secret = []
    dash = "_"
    word_to_array.to_a
    word_length = word_to_array.to_a.length
    word_length.times { secret << dash }
    return secret.join(' ')
  end

  def letter_guess(guessed_letter)
    # stores each guess and sends to "guesses" array
    alphabet = ('a'..'z')
    if guessed_letter == 'SAVE'
      save_game
    elsif guessed_letter == 'START OVER'
      start_over
    elsif alphabet.include?(guessed_letter.downcase) && guessed_letter.length == 1
      lowered_letter = guessed_letter.downcase
      puts "You guessed #{lowered_letter}!"
      puts ''
      puts "Checking to see if '#{lowered_letter}' is in the secret word.."
      puts ''
      check_letters(lowered_letter)
      return lowered_letter
    else
      puts 'Please enter a single letter or SAVE.'
      game_iteration
    end
  end

  def check_letters(lowered_letter)
    # check for matches on each guess
    if @guesses.include?(lowered_letter)
      puts "You already guessed #{lowered_letter}, try again."
      puts ''
      game_iteration
    else
      @guesses << lowered_letter
      if word_to_array.to_a.include?(lowered_letter)
        puts 'This letter is in the secret word!'
        puts ''
        @correct_array << lowered_letter
        fill_in_blanks
        game_iteration unless @incorrect_guesses == 0
      else
        puts 'This letter is not in the secret word, sorry.'
        puts ''
        wrong_guess_game_iteration
        guesses_left_counter
      end

    end
  end

  def fill_in_blanks
    # every correct guess changes the blank into the letter
    puts @correct_array.join(' ')
    puts ''
    word_to_array.each_with_index do |lett, index|
      puts "#{lett} is in the #{index} position"
    end
  end

  def letters_used
    # keeep track of letters guessed
    puts @guesses.join(' ')
    puts ''
  end

  def guesses_left_counter
    # keep track of how many incorrect guesses left
    @incorrect_guesses -= 1
  end

  def save_game
    puts 'Saving game...'
    File.new('saved_game.yaml') unless File.exist?('saved_game.yaml')
    File.open('saved_game.yaml', 'w') do |file|
      file.puts YAML.dump({
        word: @word,
        guesses: @guesses,
        incorrect_guesses: @incorrect_guesses
      })
    end
  end

  def load_game
    puts 'Loading game...'
    saved_data = YAML.load(File.read('saved_game.yaml'))
    @word = saved_data[:word]
    @guesses = saved_data[:guesses]
    @incorrect_guesses = saved_data[:incorrect_guesses]
  end

  def start_over
    Game.new
  end

end

Game.new
