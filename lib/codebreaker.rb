# require_relative "guess"
require_relative "peg/code_peg_set"
require_relative "guess_computer"
require_relative "peg/peg_types/code_peg"

# Represents a player that is a codebreaker, contains logic and methods that
# describe what the codebreaker can do, such as building the guess pattern
class Codebreaker
  include Utilities

  attr_reader :is_human, :guess

  def initialize(is_human)
    @is_human = is_human
    @guess = CodePegSet.new
    return if is_human

    @guess_computer = GuessComputer.new
  end

  def build_guess
    guess_done = false
    until guess_done
      guess.build
      break if confirm_guess?

      reset_guess
    end
  end

  def generate_guess
    self.guess = guess_computer.compute
  end

  def feed_clue_to_computer(clue)
    guess_computer.calc_response(clue)
  end

  def reset_guess
    guess.reset
  end

  private

  attr_reader :guess_computer
  attr_writer :guess

  def confirm_guess?
    user_confirmed? "Guess complete, would you like to confirm? (y/n)"
  end
end
