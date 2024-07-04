require_relative "code_peg"
require_relative "code_peg_set"

# Represents a row on the board containing code peg guesses. Also contains
# functionality to build and manipulate a guess
class Guess < CodePegSet
  include Utilities

  def initialize # rubocop:disable Lint/UselessMethodDefinition
    super
  end

  # def display
  #   @code_pegs.map do |code_peg|
  #     print code_peg.nil? ? "_ " : "#{code_peg} "
  #   end
  # end

  # def build
  #   puts "Input color for first guess of your guess pattern. Enter 'r' to start again"
  #   prompt_code_peg_choice until guess_complete?
  #   print "final guess pattern : "
  #   display
  # end

  # def reset
  #   self.code_pegs = empty_guess
  # end

  # private

  # attr_accessor :code_pegs

  # def prompt_code_peg_choice
  #   display_current_guess
  #   input = user_input

  #   if input == "r"
  #     reset_guess
  #   elsif CodePeg.valid_color? input
  #     add_code_peg_to_guess input
  #   else
  #     puts "That is not a valid color! Please try again"
  #   end
  # end

  # def empty_guess
  #   [nil, nil, nil, nil]
  # end

  # def guess_complete?
  #   @code_pegs.all? { |code_peg| !code_peg.nil? }
  # end

  # def add_code_peg_to_guess(color)
  #   return if guess_complete?

  #   code_pegs[code_pegs.index nil] = CodePeg.new(color)
  # end

  # def display_current_guess
  #   print "Your guess : "
  #   display
  #   puts ""
  # end
end
