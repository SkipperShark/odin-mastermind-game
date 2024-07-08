require "colorize"
require_relative "peg/peg_types/code_peg"
require_relative "peg/code_peg_set"

# represents an algorithm that, based on clues given by the game engine,
# constructs guesses to try to win the game. used when the codebreaker is
# the computer
class GuessComputer
  attr_accessor :clue, :guess, :guess_color_index, :solution

  def initialize
    @code_color_options = CodePeg.color_options
    # @guess = []
    # @guess_color_index = 0
    # @solution = []
  end

  def compute_donald_knuth(clue = nil)
    # possible_guess = Set.new
    code_color_options = self.code_color_options.each_with_index.map do |color, index|
      {
        color_option: color,
        color_option_code: index + 1
      }
    end
    # pp code_color_options
    puts "\n\n--------------------\n\n"

    raw = code_color_options.repeated_permutation(4).to_a

    # pp raw

    possible_guesses = raw.each_with_index.map do |guess, index|
      {
        index:,
        id: guess.map { |code_peg| code_peg[:color_option_code] }.join,
        code_pegs: guess.map { |code_peg| code_peg[:color_option] }
      }
    end

    # possible_guesses.each do |guess|
    #   pp "guess index : #{guess[:index]}, guess : #{guess[:code_pegs]}, guess id : #{guess[:id]}"
    # end

    first_turn = clue.nil?
    if first_turn
      guess_colors = possible_guesses.select { |guess| guess[:id] == "1122" }.first[:code_pegs]
      guess = CodePegSet.from_colors(guess_colors)
      puts "guess inspect : #{guess.inspect}".colorize(:blue)
      return guess
    end

    test = 1

    # if clue.nil?
    # end
  end

  # def derive_guess(prev_turn_clue)
  #   foo = prev_turn_clue
  #   puts foo

  #   possible_codes = []
  #   color_options = CodePeg.color_options
  #   color_options.combination(4) { |combination| possible_codes << combination }
  #   pp possible_codes
  #   return nil
  # end

  # def derive_guess_version_1(prev_turn_clue)
  #   puts "\n\n-----\n\n"
  #   puts "Color options : #{CodePeg::COLOR_OPTIONS}"
  #   puts "derive guess, prev_turn_clue : #{prev_turn_clue.map(&:to_s)}"
  #   puts "guess_color_index : #{guess_color_index}"
  #   puts "solution : #{printable_solution}"

  #   guess_color = CodePeg::COLOR_OPTIONS[guess_color_index]
  #   puts "guess color : #{guess_color}"

  #   # 4 clue pegs found but not all are full matches
  #   # if solution.length == 4
  #   #   num_full_matches = solution.count{ |ele| ele[:code_peg].full_match?}
  #   #   to_shuffle =
  #   # end

  #   # first turn
  #   if prev_turn_clue.empty?
  #     puts "first turn"
  #     4.times do
  #       guess << CodePeg.new(guess_color)
  #     end
  #     next_turn
  #     return guess
  #   end

  #   puts "not first turn"

  #   prev_guess_color = CodePeg::COLOR_OPTIONS[guess_color_index - 1]
  #   num_new_full_matches = prev_turn_clue.count{ |ele| ele.full_match? } - solution.count { |ele| ele[:type] == "full match"}
  #   num_new_position_matches = prev_turn_clue.count{ |ele| ele.position_match? } - solution.count { |ele| ele[:type] == "position match"}
  #   puts "num_new_full_matches : #{num_new_full_matches}"
  #   puts "num_new_position_matches : #{num_new_position_matches}"
  #   puts "prev_guess_color : #{prev_guess_color}"

  #   num_new_full_matches.times do
  #     self.solution << {
  #       code_peg: CodePeg.new(prev_guess_color),
  #       type: "full match"
  #     }
  #   end

  #   num_new_position_matches.times do
  #     self.solution << {
  #       code_peg: CodePeg.new(prev_guess_color),
  #       type: "position match"
  #     }
  #   end

  #   puts "solution after processing clue : #{printable_solution}"

  #   self.guess = []
  #   self.guess += solution.map { |ele| ele[:code_peg]}
  #   puts "guess + solution : #{printable_guess}"

  #   num_new_guesses = 4 - solution.length
  #   puts "num_new_guesses : #{num_new_guesses}"

  #   num_new_guesses.times do
  #     self.guess << CodePeg.new(guess_color)
  #   end

  #   puts "guess + solution + new : #{printable_guess}"
  #   next_turn
  #   return guess
  # end

  private

  attr_reader :code_color_options

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
