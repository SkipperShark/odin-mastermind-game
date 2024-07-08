require_relative "peg_types/code_peg"
require_relative "peg_set"

# represents a set of code pegs, which may either be a guess or a secret
class CodePegSet < PegSet
  include Utilities

  def initialize # rubocop:disable Lint/UselessMethodDefinition
    super
  end

  def self.from_colors(colors)
    code_peg_set = new
    colors.each { |color| code_peg_set.add_to_set(color) }
    code_peg_set
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

  def add_to_set(color)
    return if complete?

    pegs[pegs.index nil] = CodePeg.new(color)
  end

  private

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
