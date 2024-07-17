require "colorize"

require_relative "board"
require_relative "guess_computer"
require_relative "codebreaker"
require_relative "codemaker"
require_relative "clue_computer"

# main game engine/driver, contains the turn logic, game end condition logic,
# and core game logic
class Game
  include Utilities

  def initialize
    @board = Board.new
    @winner = nil
    @turn = 1
    game_start_message

    codemaker_is_human = codemaker_human?
    codebreaker_is_human = !codemaker_is_human

    @codemaker = Codemaker.new(codemaker_is_human)
    @codebreaker = Codebreaker.new(codebreaker_is_human)
    puts "codemaker_is_human : #{codemaker_is_human}".colorize(:blue)
    puts "codebreaker_is_human : #{codebreaker_is_human}".colorize(:blue)
  end

  def play
    puts "\n\nGame Start!\n\n".colorize(:green)
    if codebreaker.is_human == true
      play_codebreaker_human
    elsif codemaker.is_human == true
      play_codemaker_human
    end
    game_end_message
  end

  private

  attr_accessor :winner, :guess, :turn, :clue, :board
  attr_reader :codemaker, :codebreaker

  def play_codebreaker_human
    codemaker.generate_secret
    codemaker.display_secret
    while winner.nil?
      board.show
      puts "\nturn : #{turn}".colorize(:green)
      codebreaker.build_guess
      clue = compute_clue(codebreaker.guess, codemaker.secret)
      board.add_solve_attempt(codebreaker.guess, clue)
      self.winner = determine_winner clue

      if winner.nil?
        next_turn
        codebreaker.reset_guess
      end
    end
  end

  def play_codemaker_human
    codemaker.build_secret
    while winner.nil?
      puts "turn : #{turn}"
      codemaker.display_secret
      board.show
      codebreaker.generate_guess
      clue = compute_clue(codebreaker.guess, codemaker.secret)
      codebreaker.feed_clue_to_computer clue
      board.add_solve_attempt(codebreaker.guess, clue)
      self.winner = determine_winner clue
      next_turn
      codebreaker.reset_guess
      puts "----\n\n-----"
    end
  end

  def game_start_message
    puts "Welcome to mastermind\n\n".colorize(:green)
    puts "these are the color options : #{CodePeg::COLOR_OPTIONS}\n"
    print "\n"
  end

  def codemaker_human?
    valid_choice = false
    until valid_choice == true
      puts "Would you like to be the codemaker? (y/n). 'n' would make you the codebreaker".colorize(:yellow)
      input = user_input
      case input
      when "y" then return true
      when "n" then return false
      else puts "I'm not sure what you mean, please try again".colorize(:!)
      end
    end
  end

  def determine_winner(clue)
    codebreaker_won = clue.all_full_matches?
    codemaker_won = turn >= 12 && !codebreaker_won
    if codebreaker_won == true
      return "codebreaker"
    elsif codemaker_won == true
      return "codemaker"
    end

    nil
  end

  def next_turn
    self.turn += 1
  end

  def compute_clue(guess, secret)
    clue_computer = ClueComputer.new(guess, secret)
    clue_computer.compute
  end

  def game_end_message
    puts "game ended!".colorize(:green)
    puts "WINNER : #{winner}".colorize(:green)
    puts "Thanks for playing! Goodbye!".colorize(:green)
    puts "Board end game state\n".colorize(:green)
    board.show
  end

end
