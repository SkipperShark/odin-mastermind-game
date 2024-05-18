# frozen_string_literal: true

require_relative 'Player'
require_relative 'Board'
require_relative 'KeyPeg'
require_relative 'CodePeg'


class Game < Utilities

  def initialize
    super
    @board = Board.new
    @winner = nil
    @turn = 1

    if player_is_codemaker
      @codemaker = Player.new(is_codemaker: true, is_human: true)
      @codebreaker = Player.new(is_codemaker: false, is_human: false)
    else
      @codemaker = Player.new(is_codemaker: true, is_human: false)
      @codebreaker = Player.new(is_codemaker: false, is_human: true)
    end

    # @codemaker = @computer
    # @codebreaker = @human

    @guess = []
    @clue = []

    puts "secret code : #{@codemaker.debug_get_code}"
  end

  def introduction
    puts "Welcome to mastermind\n\n"
    puts "these are the color options : #{CodePeg::COLOR_OPTIONS}\n"
    # @board.show
    print "\n"
  end

  def play
    while winner.nil?
      board.show
      puts "turn : #{turn}"
      codebreaker.build_guess_pattern
      unless user_confirmed_guess
        codebreaker.reset_guess
        next
      end
      compare_guess_to_secret
      update_board
      if codebreaker_won?
        self.winner = "codebreaker"
      elsif codemaker_won?
        self.winner = "codemaker"
      end
      next_turn
    end
    board.show
    puts "game ended! Thanks for playing. Winner : #{winner}"
  end

  private

  attr_accessor :winner, :guess, :turn, :clue, :board
  attr_reader :codemaker, :codebreaker

  def player_is_codemaker
    valid_choice = false
    until valid_choice == true
      puts "Would you like to be the codemaker? (y/n). 'n' would make you the codebreaker"
      input = user_input
      if input == "y"
        return true
      elsif input == "n"
        return false
      else
        puts "I'm not sure what you mean, please try again"
      end
    end
  end

  def codemaker_won?
    turn >= 12 && !codebreaker_won?
  end

  def next_turn
    self.clue = []
    self.guess = []
    self.turn += 1
  end

  def update_board
    board.add_guess(guess, clue)
  end

  def codebreaker_won?
    clue.count { |key_peg| key_peg.full_match? } >= 4
  end

  def compare_guess_to_secret
    secret_pattern = codemaker.code.clone.map(&:to_s)
    guess_pattern = guess.clone.map(&:to_s)

    # find color and position matches
    guess_pattern.each.with_index do |guess_color, i|
      secret_pattern.each.with_index do |secret_color, y|
        if guess_color == secret_color and i == y
          self.clue << KeyPeg.full_match
          guess_pattern[i] = nil
          secret_pattern[y] = nil
          break
        end
      end
    end
    guess_pattern.compact!
    secret_pattern.compact!

    # find position matches only
    guess_pattern.each.with_index do |guess_color, i|
      secret_pattern.each.with_index do |secret_color, y|
        if guess_color == secret_color
          self.clue << KeyPeg.position_match
          guess_pattern[i] = nil
          secret_pattern[y] = nil
          break
        end
      end
    end

    guess_pattern.compact!
    secret_pattern.compact!

    # puts "\n\nafter first iteration \n\n"
    # puts "secret_pattern : #{secret_pattern}"
    # puts "guess_pattern : #{guess_pattern}"
    # puts "clue : #{clue}"

  end

  def user_confirmed_guess
    valid_choice = false
    until valid_choice == true
      puts "guess pattern complete, would you like to confirm? (y/n)"
      input = user_input
      if input == "y"
        return true
      elsif input == "n"
        return false
      else
        puts "I'm not sure what you mean, please try again"
      end
    end
  end

  # def build_guess_pattern
  #   puts 'Input color for first guess of your guess pattern. Enter "r" to start again'
  #   until guess_complete
  #     puts "your guesses : #{guess.map { |ele| ele.color}}"
  #     input = user_input
  #     if input == "r"
  #       self.guess = []
  #       next
  #     end
  #     unless valid_user_input? input
  #       puts "That is not a valid color! Please try again"
  #       next
  #     end
  #     self.guess << CodePeg.new(input)
  #   end
  #   puts "final guess pattern : #{guess.map { |ele| ele.color}}"
  # end

  # def user_input
  #   gets.chomp.downcase.lstrip.rstrip
  # end

  # def valid_user_input?(user_input)
  #   begin
  #     CodePeg.new user_input
  #     true
  #   rescue ArgumentError
  #     false
  #   end
  # end

  # def guess_complete
  #   @guess.length == 4
  # end

  # def reset_guess
  #   @guess.clear
  # end
end
