require "colorize"
require_relative "peg/peg_types/code_peg"
require_relative "peg/code_peg_set"

# represents an algorithm that, based on clues given by the game engine,
# constructs guesses to try to win the game. used when the codebreaker is
# the computer
class GuessComputer
  def initialize
    @code_color_options = CodePeg.color_options
    @guess_options = compute_guess_options

    @current_option = nil
    @guess_history = []

    show_guess_options
    pp @guess_history
  end

  def compute_donald_knuth
    first_turn = guess_history.empty?
    if first_turn
      self.current_option = guess_options.select { |option| option[:id] == "1122" }.first
      guess = construct_guess
      puts "guess : #{guess}".colorize(:blue)
      return guess
    end
    nil
  end

  def calc_response(clue)
    num_position_matches = clue.pegs.count { |key_peg| key_peg&.position_match? }
    num_full_matches = clue.pegs.count { |key_peg| key_peg&.full_match? }
    puts "num_full_matches : #{num_full_matches}, num_partial_matches : #{num_position_matches}"

    # if guess didnt get any matches, remove guess colors from possible options
    if num_full_matches + num_full_matches <= 0
      guess_colors = current_option[:colors].uniq
      self.guess_options = guess_options.filter do |option|
        !guess_colors.intersect?(option[:colors])
      end
    end
    add_to_guess_history
    show_guess_options
    puts "End of turn. Guess history:".colorize(:cyan)
    pp @guess_history
  end

  private

  attr_accessor :guess_options, :current_option, :guess_history
  attr_reader :code_color_options

  def construct_guess
    CodePegSet.from_colors(current_option[:colors])
  end

  def add_to_guess_history
    guess_history << {
      colors: current_option[:colors],
      score: guess_options.size
    }
  end

  def show_guess_options
    guess_options.each do |guess|
      pp "index: #{guess[:index]}, colors: #{guess[:colors]}, id: #{guess[:id]}"
    end
  end

  def compute_guess_options
    options = code_color_options.each.with_index(1).map do |color, index|
      {
        color:,
        code: index
      }
    end
    # pp code_color_options
    # puts "\n\n--------------------\n\n"

    raw = options.repeated_permutation(4).to_a

    # pp raw

    raw.each_with_index.map do |guess, index|
      {
        index:,
        id: guess.map { |code_peg| code_peg[:code] }.join,
        colors: guess.map { |code_peg| code_peg[:color] }
      }
    end
  end

  # def compute_donald_knuth(clue = nil)
  #   # possible_guess = Set.new

  #   first_turn = clue.nil?
  #   if first_turn
  #     # guess_option = guess_options.select { |guess| guess[:id] == "1122" }.first
  #     # guess_option_colors = guess_option[:colors]
  #     # self.guess = CodePegSet.from_colors(guess_option_colors)
  #     # puts "guess inspect : #{guess.inspect}".colorize(:blue)
  #     # puts "guess : #{guess}".colorize(:blue)
  #     self.current_option = guess_options.select { |option| option[:id] == "1122" }.first
  #     guess = CodePegSet.from_colors(current_option[:colors])
  #     # puts "guess inspect : #{guess.inspect}".colorize(:blue)
  #     puts "guess : #{guess}".colorize(:blue)
  #     add_to_guess_history guess
  #     return guess
  #   end

  #   # puts "clue : #{clue}"
  #   # puts "clue pegs : #{clue.pegs}"
  #   # puts "clue pegs class : #{clue.pegs.class}"

  #   num_position_matches = clue.pegs.count { |key_peg| key_peg&.position_match? }
  #   num_full_matches = clue.pegs.count { |key_peg| key_peg&.full_match? }

  #   puts "num_full_matches : #{num_full_matches}, num_partial_matches : #{num_position_matches}"
  #   # if guess didnt get any matches, remove guess colors from possible options
  #   if num_full_matches + num_full_matches <= 0
  #     guess_colors = current_option[:colors].uniq
  #     puts "guess colors : #{guess_colors}"
  #     self.guess_options = guess_options.filter do |option|
  #       !guess_colors.intersect?(option[:colors])
  #     end
  #   end
  #   nil
  # end
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

  # attr_reader :code_color_options

  # def next_turn
  #   self.guess_color_index += 1
  # end

  # def printable_guess
  #   guess.map(&:to_s)
  # end

  # def printable_solution
  #   solution.map { |ele| ele[:code_peg].to_s}
  # end
end
