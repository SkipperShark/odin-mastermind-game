# require_relative "guess"
require_relative "peg/code_peg_set"

# Represents a player that is a codebreaker, contains logic and methods that
# describe what the codebreaker can do, such as building the guess pattern
class Codebreaker
  include Utilities

  attr_reader :is_human, :guess

  def initialize(is_human)
    @is_human = is_human
    @guess = CodePegSet.new
  end

  def build_guess
    guess_done = false
    until guess_done
      guess.build
      break if confirm_guess?

      reset_guess
    end
  end

  def reset_guess
    guess.reset
  end

  private

  def confirm_guess?
    user_confirmed? "Guess complete, would you like to confirm? (y/n)"
  end

end
