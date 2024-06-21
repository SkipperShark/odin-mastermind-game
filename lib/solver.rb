require_relative 'code_peg'
require_relative 'key_peg'

class Solver
  attr_accessor :clue, :guess, :guess_color_index, :solution

  def initialize
    @guess = []
    @guess_color_index = 0
    @solution = []
  end

  def derive_guess(prev_turn_clue)
    foo = prev_turn_clue
    puts foo

    possible_codes = []
    color_options = CodePeg.color_options
    color_options.combination(4) { |combination| possible_codes << combination }
    pp possible_codes
    return nil
  end

  def derive_guess_version_1(prev_turn_clue)
    puts "\n\n-----\n\n"
    puts "Color options : #{CodePeg::COLOR_OPTIONS}"
    puts "derive guess, prev_turn_clue : #{prev_turn_clue.map(&:to_s)}"
    puts "guess_color_index : #{guess_color_index}"
    puts "solution : #{printable_solution}"

    guess_color = CodePeg::COLOR_OPTIONS[guess_color_index]
    puts "guess color : #{guess_color}"

    # 4 clue pegs found but not all are full matches
    # if solution.length == 4
    #   num_full_matches = solution.count{ |ele| ele[:code_peg].full_match?}
    #   to_shuffle =
    # end

    # first turn
    if prev_turn_clue.empty?
      puts "first turn"
      4.times do
        guess << CodePeg.new(guess_color)
      end
      next_turn
      return guess
    end

    puts "not first turn"

    prev_guess_color = CodePeg::COLOR_OPTIONS[guess_color_index - 1]
    num_new_full_matches = prev_turn_clue.count{ |ele| ele.full_match? } - solution.count { |ele| ele[:type] == "full match"}
    num_new_position_matches = prev_turn_clue.count{ |ele| ele.position_match? } - solution.count { |ele| ele[:type] == "position match"}
    puts "num_new_full_matches : #{num_new_full_matches}"
    puts "num_new_position_matches : #{num_new_position_matches}"
    puts "prev_guess_color : #{prev_guess_color}"

    num_new_full_matches.times do
      self.solution << {
        code_peg: CodePeg.new(prev_guess_color),
        type: "full match"
      }
    end

    num_new_position_matches.times do
      self.solution << {
        code_peg: CodePeg.new(prev_guess_color),
        type: "position match"
      }
    end

    puts "solution after processing clue : #{printable_solution}"

    self.guess = []
    self.guess += solution.map { |ele| ele[:code_peg]}
    puts "guess + solution : #{printable_guess}"

    num_new_guesses = 4 - solution.length
    puts "num_new_guesses : #{num_new_guesses}"

    num_new_guesses.times do
      self.guess << CodePeg.new(guess_color)
    end

    puts "guess + solution + new : #{printable_guess}"
    next_turn
    return guess
  end

  private

    def next_turn
      self.guess_color_index += 1
    end

    def printable_guess
      guess.map(&:to_s)
    end

    def printable_solution
      solution.map { |ele| ele[:code_peg].to_s}
    end
end
