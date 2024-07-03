require_relative "guess"

# Represents a player that is a codebreaker, contains logic and methods that
# describe what the codebreaker can do, such as building the guess pattern
class Codebreaker
  attr_reader :is_human

  def initialize(is_human)
    @is_human = is_human
    @guess = Guess.new
  end

  def build_guess
    @guess.build
  end
end
