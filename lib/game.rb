require_relative "board"
# require_relative "key_peg"
# require_relative "code_peg"
require_relative "solver"
require_relative "utilites"
require_relative "codebreaker"
require_relative "codemaker"
require_relative "peg/peg_types/key_peg"
require_relative "clue"

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
    codebreaker_is_human = !codebreaker_is_human

    # @codemaker = Player.codemaker(codemaker_is_human)
    # @codebreaker = Player.codebreaker(codebreaker_is_human)
    @codemaker = Codemaker.new(codemaker_is_human)
    @codebreaker = Codebreaker.new(codebreaker_is_human)
  end

  def play
    puts "\n\nGame Start!\n\n"
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
    if codebreaker.is_human == true
      codemaker.generate_secret
      codemaker.display_secret

      while winner.nil?
        board.show
        puts "turn : #{turn}"
        # puts "guess before build: #{codebreaker.guess}"
        codebreaker.build_guess
        # puts "guess after: #{codebreaker.guess}"
        # clue = compute_clue(codebreaker.guess, codemaker.secret)
        clue = Clue.new(codebreaker.guess, codemaker.secret)
        puts "clue : #{clue.pegs}"




        # board.add_guess(codebreaker.guess, clue)
        # self.winner = determine_winner clue
        # next_turn
        # codebreaker.reset_guess
      end
    end

    #todo to be done later as this is more complex
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

    board.show
    puts "game ended! Thanks for playing. WINNER : #{winner}"

  end

  private

  attr_accessor :winner, :guess, :turn, :clue, :board
  attr_reader :codemaker, :codebreaker

  def game_start_message
    puts "Welcome to mastermind\n\n"
    puts "these are the color options : #{CodePeg::COLOR_OPTIONS}\n"
    print "\n"
  end

  def codemaker_human?
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

  def determine_winner (clue)
    codebreaker_won = clue.count { |code_peg| code_peg.full_match? } >= 4
    codemaker_won = turn >= 12 &&  !codebreaker_won
    puts "------------ determine_winner ------------"
    puts "codebreaker_won : #{codebreaker_won}"
    puts "codemaker_won : #{codemaker_won}"
    if codebreaker_won == true
      return "codebreaker"
    elsif codemaker_won == true
      return "codemaker"
    end
    return nil
  end

  def next_turn
    self.turn += 1
  end

  # def compute_clue(guess, secret)
  #   secret_pattern = secret.clone.map(&:to_s)
  #   guess_pattern = guess.clone.map(&:to_s)
  #   clue = []

  #   # find color and position matches
  #   guess_pattern.each.with_index do |guess_color, i|
  #     secret_pattern.each.with_index do |secret_color, y|
  #       if (guess_color == secret_color) && (i == y)
  #         clue << KeyPeg.full_match
  #         guess_pattern[i] = nil
  #         secret_pattern[y] = nil
  #         break
  #       end
  #     end
  #   end
  #   guess_pattern.compact!
  #   secret_pattern.compact!

  #   # find position matches only
  #   guess_pattern.each.with_index do |guess_color, i|
  #     secret_pattern.each.with_index do |secret_color, y|
  #       if guess_color == secret_color
  #         clue << KeyPeg.position_match
  #         guess_pattern[i] = nil
  #         secret_pattern[y] = nil
  #         break
  #       end
  #     end
  #   end

  #   guess_pattern.compact!
  #   secret_pattern.compact!
  #   clue
  # end
end
