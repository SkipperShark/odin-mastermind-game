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

    # @codemaker = Player.codemaker(codemaker_is_human)
    # @codebreaker = Player.codebreaker(codebreaker_is_human)
    @codemaker = Codemaker.new(codemaker_is_human)
    @codebreaker = Codebreaker.new(codebreaker_is_human)
    puts "codemaker_is_human : #{codemaker_is_human}".colorize(:blue)
    puts "codebreaker_is_human : #{codebreaker_is_human}".colorize(:blue)
  end

  def play
    puts "\n\nGame Start!\n\n".colorize(:green)

    if codebreaker.is_human == true
      codemaker.generate_secret
      codemaker.display_secret

      while winner.nil?
        board.show
        puts "\nturn : #{turn}".colorize(:green)
        # puts "guess before build: #{codebreaker.guess}"
        codebreaker.build_guess
        # puts "guess after: #{codebreaker.guess}"
        clue = compute_clue(codebreaker.guess, codemaker.secret)
        # puts "\n\nend of turn inspection\n".colorize(:green)
        # puts "guess : #{codebreaker.guess}".colorize(:green)
        # puts "clue : #{clue}".colorize(:green)
        # puts "clue inspect : #{clue.inspect}"
        # puts "\n\n--------------- end turn\n\n".colorize(:green)
        board.add_solve_attempt(codebreaker.guess, clue)
        self.winner = determine_winner clue

        if winner.nil?
          next_turn
          codebreaker.reset_guess
        end
      end

    elsif codemaker.is_human == true
      codemaker.build_secret
      # guess_computer.compute_donald_knuth
      clue = nil
      while winner.nil?
        puts "turn : #{turn}"
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
    # elsif codemaker.is_human == true
    # if codemaker.is_human == true
    #   solver = Solver.new
    #   clue = []
    #   while winner.nil?
    #     puts "turn : #{turn}"
    #     board.show
    #     codebreaker.guess = solver.derive_guess(clue)
    #     clue = compute_clue(codebreaker.guess, codemaker.secret)
    #     board.add_guess(codebreaker.guess, clue)
    #     self.winner = determine_winner clue
    #     next_turn
    #     codebreaker.reset_guess
    #     puts "----\n\n-----"
    #   end
    # end

    puts "game ended!".colorize(:green)
    puts "WINNER : #{winner}".colorize(:green)
    puts "Thanks for playing! Goodbye!".colorize(:green)
    puts "Board end game state\n".colorize(:green)
    board.show
  end

  # def play
  #   puts "\n\nGame Start!\n\n".colorize(:green)
    # puts "secret code : #{@codemaker.show_secret}\n\n"

    # if codebreaker.is_human
    #   while winner.nil?
    #     board.show
    #     puts "turn : #{turn}"
    #     codebreaker.build_guess_pattern
    #     unless codebreaker.user_confirmed?
    #       codebreaker.reset_guess
    #       next
    #     end
    #     clue = compute_clue(codebreaker.guess, codemaker.secret)
    #     board.add_guess(codebreaker.guess, clue)
    #     self.winner = determine_winner clue
    #     next_turn
    #     codebreaker.reset_guess
    #   end
    # elsif codemaker.is_human == true
    # if codemaker.is_human == true
    #   solver = Solver.new
    #   clue = []
    #   while winner.nil?
    #     puts "turn : #{turn}"
    #     board.show
    #     codebreaker.guess = solver.derive_guess(clue)
    #     clue = compute_clue(codebreaker.guess, codemaker.secret)
    #     board.add_guess(codebreaker.guess, clue)
    #     self.winner = determine_winner clue
    #     next_turn
    #     codebreaker.reset_guess
    #     puts "----\n\n-----"
    #   end
    # end

  #   board.show
  #   puts "game ended! Thanks for playing. WINNER : #{winner}".colorize(:yellow)
  # end

  private

  attr_accessor :winner, :guess, :turn, :clue, :board
  attr_reader :codemaker, :codebreaker

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
    puts "------------ win condition checking ------------".colorize(:green)
    puts "codebreaker_won : #{codebreaker_won}".colorize(:green)
    puts "codemaker_won : #{codemaker_won}".colorize(:green)
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
  # def determine_winner (clue)
  #   codebreaker_won = clue.count { |code_peg| code_peg.full_match? } >= 4
  #   codemaker_won = turn >= 12 &&  !codebreaker_won
  #   puts "------------ determine_winner ------------"
  #   puts "codebreaker_won : #{codebreaker_won}"
  #   puts "codemaker_won : #{codemaker_won}"
  #   if codebreaker_won == true
  #     return "codebreaker"
  #   elsif codemaker_won == true
  #     return "codemaker"
  #   end
  #   return nil
  # end
end
