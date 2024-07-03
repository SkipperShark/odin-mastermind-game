require_relative "guess"

# Represents a player that is a codebreaker, contains logic and methods that
# describe what the codebreaker can do, such as building the guess pattern
class Codebreaker
  include Utilities

  attr_reader :is_human

  def initialize(is_human)
    @is_human = is_human
    @guess = Guess.new
  end

  def build_guess
    @guess.build
  end

  def confirm_guess?
    user_confirmed? "Guess complete, would you like to confirm? (y/n)"
  end

  def reset_guess
    @guess.reset
  end
end
