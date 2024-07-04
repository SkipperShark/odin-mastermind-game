require_relative "code_peg"

# represents a set of code pegs, which may either be a guess or a secret
class CodePegSet
  include Utilities

  def initialize
    @code_pegs = empty
  end

  def display
    @code_pegs.map do |code_peg|
      print code_peg.nil? ? "_ " : "#{code_peg} "
    end
  end

  def build
    puts "Input color for your first code peg. Enter 'r' to start again"
    prompt_code_peg_choice until complete?
    print "final : "
    display
    puts ""
  end

  def reset
    self.code_pegs = empty
  end

  private

  attr_accessor :code_pegs

  def prompt_code_peg_choice
    display_current_set
    input = user_input

    if input == "r"
      reset
    elsif CodePeg.valid_color? input
      add_to_set input
    else
      puts "That is not a valid color! Please try again"
    end
  end

  def empty
    [nil, nil, nil, nil]
  end

  def complete?
    @code_pegs.all? { |code_peg| !code_peg.nil? }
  end

  def add_to_set(color)
    return if complete?

    code_pegs[code_pegs.index nil] = CodePeg.new(color)
  end

  def display_current_set
    print "Your set : "
    display
    puts ""
  end
end
