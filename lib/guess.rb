require_relative "utilites"

# Represents a row on the board containing code peg guesses. Also contains
# functionality to build and manipulate a guess
class Guess
  include Utilities
  def initialize
    @code_pegs = empty_guess
  end

  def display
    # return if no_code_pegs
    @code_pegs.map do |code_peg|
      print code_peg.nil? ? "_ " : "#{code_peg} "
    end
  end

  def build_guess_pattern
    puts  "Input color for first guess of your guess pattern.
          Enter 'r' to start again"
    until guess_complete?
      # puts "your guesses : #{guess.map { |ele| ele.color}}"
      display
      input = user_input
      if input == "r"
        reset_guess
        next
      end


      #todo valid user input is not defined here, it should be a code peg method
      unless valid_user_input? input
        puts "That is not a valid color! Please try again"
        next
      end
      color = input
      add_code_peg_to_guess color
    end
    # puts "final guess pattern : #{guess.map { |ele| ele.color}}"
    print "final guess pattern : "
    display
  end

  private

  attr_accessor :code_pegs

  def reset_guess
    self.code_pegs = empty_guess
  end

  def empty_guess
    [nil, nil, nil, nil]
  end

  def guess_complete?
    @code_pegs.all? { |code_peg| !code_peg.nil? }
  end

  def add_code_peg_to_guess(color)
    return if guess_complete?

    code_pegs[code_pegs.index nil] = CodePeg.new(color)
  end

  # def no_code_pegs
  #   @code_pegs.all?(&:nil?)
  # end
end
