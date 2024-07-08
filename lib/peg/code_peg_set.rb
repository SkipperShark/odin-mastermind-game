require_relative "peg_types/code_peg"
require_relative "peg_set"

# represents a set of code pegs, which may either be a guess or a secret
class CodePegSet < PegSet
  include Utilities

  def initialize # rubocop:disable Lint/UselessMethodDefinition
    super
  end

  def from_colors(colors)
    colors.each { |color| add_to_set(color) }
  end

  def build
    puts "Input color for your first code peg. Enter 'r' to start again"
    prompt_code_peg_choice until complete?
    puts "final : #{self}"
  end

  def generate_random
    pegs.each do
      add_to_set(CodePeg.random_color)
    end
  end

  private

  def add_to_set(color)
    return if complete?

    pegs[pegs.index nil] = CodePeg.new(color)
  end

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
end
