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

    # @guess = []
    # @clue = []

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
      unless codebreaker.user_confirmed_guess
        codebreaker.reset_guess
        next
      end
      clue = compute_clue(codebreaker.guess, codemaker.code)
      board.add_guess(codebreaker.guess, clue)
      if codebreaker_won? clue
        self.winner = "codebreaker"
      elsif codemaker_won?
        self.winner = "codemaker"
      end
      next_turn
      codebreaker.reset_guess
    end
    board.show
    puts "game ended! Thanks for playing. WINNER : #{winner}"
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
    self.turn += 1
  end

  def codebreaker_won?(clue)
    clue.count { |key_peg| key_peg.full_match? } >= 4
  end

  def compute_clue(guess, secret)
    secret_pattern = secret.clone.map(&:to_s)
    guess_pattern = guess.clone.map(&:to_s)
    clue = []

    # find color and position matches
    guess_pattern.each.with_index do |guess_color, i|
      secret_pattern.each.with_index do |secret_color, y|
        if guess_color == secret_color and i == y
          clue << KeyPeg.full_match
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
          clue << KeyPeg.position_match
          guess_pattern[i] = nil
          secret_pattern[y] = nil
          break
        end
      end
    end

    guess_pattern.compact!
    secret_pattern.compact!
    return clue
  end
end
